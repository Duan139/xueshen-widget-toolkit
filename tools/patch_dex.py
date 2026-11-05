"""Repair the register mis-alignment in WidgetCountdownHelper.isWithinEveningBlock.

isWithinEveningBlock:(JII)Z  registers=12, insns_size=36, body at 0x7aabe4
static (JII) => params occupy v8..v11:
    v8  = long low half   (nowMillis)
    v9  = long high half
    v10 = int  startPeriod
    v11 = int  endPeriod

Mod9's body calls startTimeForPeriod(v9) / endTimeForPeriod(v10) -- shifted one
register, so v9 (Long High Half) is passed where an Integer is required. ART
rejects the whole class at verification, which kills MainActivity.onResume:164
the first time the widget countdown path runs (i.e. right after login returns).

Fix: v9 -> v10, v10 -> v11. Two operand bytes, identical code size, no offsets move.

DEX header layout (api 38 / dex\n038):
    0x00  magic[8]
    0x08  checksum   adler32 over [0x0C, file_size)
    0x0C  signature  sha1     over [0x20, file_size)
"""
import hashlib
import struct
import sys
import zipfile
import zlib

DST = r"<WORKSPACE>\archive\xueshen-mod9"
SRC = DST + r"\candidate-mod9.apk"
OUT = DST + r"\mod9-fixed-unsigned.apk"

START_CALL = bytes.fromhex("71100ddf0900")  # invoke-static {v9}  startTimeForPeriod:(I)
END_CALL = bytes.fromhex("7110f1de0a00")    # invoke-static {v10} endTimeForPeriod:(I)
FIX_START = bytes.fromhex("71100ddf0a00")   # invoke-static {v10}
FIX_END = bytes.fromhex("7110f1de0b00")     # invoke-static {v11}

BODY_LO, BODY_HI = 0x7AABE4, 0x7AABE4 + 36 * 2


def header_ok(dex: bytes) -> bool:
    sha = dex[0x0C:0x20] == hashlib.sha1(dex[0x20:]).digest()
    stored = struct.unpack("<I", dex[0x08:0x0C])[0]
    adl = stored == (zlib.adler32(dex[0x0C:], 1) & 0xFFFFFFFF)
    size = struct.unpack("<I", dex[0x20:0x24])[0]
    print("  sha1:%s adler32:%s file_size:%s==%s" % (sha, adl, size, len(dex)))
    return sha and adl


def rehash(dex: bytes) -> bytes:
    dex = dex[:0x0C] + hashlib.sha1(dex[0x20:]).digest() + dex[0x20:]
    dex = dex[:0x08] + struct.pack("<I", zlib.adler32(dex[0x0C:], 1) & 0xFFFFFFFF) + dex[0x0C:]
    return dex


def main() -> int:
    with zipfile.ZipFile(SRC) as z:
        dex = z.read("classes.dex")
    print("classes.dex size=%d magic=%s" % (len(dex), dex[:8]))
    print("original header (must already be valid):")
    if not header_ok(dex):
        print("ABORT: source dex header is not valid, my offset math is wrong")
        return 1

    for name, pat in (("start", START_CALL), ("end", END_CALL)):
        n, off = dex.count(pat), dex.find(pat)
        print("%s call: count=%d offset=%s" % (name, n, hex(off)))
        if n != 1:
            print("ABORT: expected exactly one %s pattern" % name)
            return 2
        if not (BODY_LO <= off < BODY_HI):
            print("ABORT: %s call at %s outside body [%s,%s)"
                  % (name, hex(off), hex(BODY_LO), hex(BODY_HI)))
            return 3

    patched = dex.replace(START_CALL, FIX_START).replace(END_CALL, FIX_END)
    if len(patched) != len(dex):
        print("ABORT: size changed")
        return 4
    assert patched.count(FIX_START) == 1 and patched.count(FIX_END) == 1
    # nothing else may have moved
    assert patched[:0x7AABE4] == dex[:0x7AABE4]

    patched = rehash(patched)
    print("patched header:")
    if not header_ok(patched):
        print("ABORT: patched header invalid")
        return 5

    with zipfile.ZipFile(SRC) as zin, zipfile.ZipFile(OUT, "w") as zout:
        for item in zin.infolist():
            if item.filename.startswith("META-INF/") and (
                item.filename.endswith((".SF", ".RSA", ".DSA", ".EC"))
                or item.filename == "META-INF/MANIFEST.MF"
            ):
                continue  # old signature block is dead; re-signed afterwards
            data = patched if item.filename == "classes.dex" else zin.read(item.filename)
            zi = zipfile.ZipInfo(item.filename, date_time=item.date_time)
            zi.compress_type = item.compress_type
            zi.external_attr = item.external_attr
            zout.writestr(zi, data)

    with zipfile.ZipFile(OUT) as z:
        got = z.read("classes.dex")
        print("unsigned apk: entries=%d testzip=%s" % (len(z.infolist()), z.testzip()))
    if got != patched:
        print("ABORT: dex round-trip mismatch")
        return 6
    print("OK ->", OUT)
    return 0


if __name__ == "__main__":
    sys.exit(main())
