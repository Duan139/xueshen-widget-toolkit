"""Patch the isWithinEveningBlock register mis-alignment in a Mod9-lineage APK.

Usage: patch_methodlevel.py <in.apk> <out-unsigned.apk>

isWithinEveningBlock:(JII)Z is static, so v8..v11 hold (long lo, long hi, start, end).
Mod9 calls startTimeForPeriod(v9)/endTimeForPeriod(v10) -- one register short, so the
Long high half is passed where an Integer is required and ART rejects the whole class.

Fix: v9 -> v10, v10 -> v11. The two invoke-static instructions differ in method index
between Mod9 revisions, so the index bytes are carried through untouched.
"""
import hashlib
import re
import struct
import sys
import zipfile
import zlib


def rehash(dex: bytes) -> bytes:
    dex = dex[:0x0C] + hashlib.sha1(dex[0x20:]).digest() + dex[0x20:]
    dex = dex[:0x08] + struct.pack("<I", zlib.adler32(dex[0x0C:], 1) & 0xFFFFFFFF) + dex[0x0C:]
    return dex


def header_ok(dex: bytes) -> bool:
    sha = dex[0x0C:0x20] == hashlib.sha1(dex[0x20:]).digest()
    stored = struct.unpack("<I", dex[0x08:0x0C])[0]
    adl = stored == (zlib.adler32(dex[0x0C:], 1) & 0xFFFFFFFF)
    return sha and adl


def set_reg(ins: bytes, reg: int) -> bytes:
    """invoke-static {vX}, meth@BBBB  ==  71 10 BB BB XX 00 ; rewrite byte 4."""
    assert len(ins) == 6 and ins[0] == 0x71 and ins[1] == 0x10, ins.hex(" ")
    return ins[:4] + bytes([reg, 0x00])


def main() -> int:
    src, out = sys.argv[1], sys.argv[2]
    with zipfile.ZipFile(src) as z:
        dex = z.read("classes.dex")
    print("classes.dex size=%d header_ok=%s" % (len(dex), header_ok(dex)))
    if not header_ok(dex):
        print("ABORT: source header invalid")
        return 1

    # The method body opens with exactly these 16 bytes:
    #   7110 BBBB 0900  0c00     invoke-static {v9}  startTimeForPeriod:(I)
    #   7110 CCCC 0a00  0c01     invoke-static {v10} endTimeForPeriod:(I)
    seq = re.compile(rb"\x71\x10..\x09\x00\x0c\x00\x71\x10..\x0a\x00\x0c\x01", re.DOTALL)
    hits = list(seq.finditer(dex))
    print("sequence matches: %d" % len(hits))
    if len(hits) != 1:
        print("ABORT: expected exactly one match of the two-instruction prefix")
        return 2

    m = hits[0]
    lo, hi = m.start(), m.end()
    assert hi - lo == 16, (hex(lo), hi - lo)
    run = dex[lo:hi]
    print("at %s  before: %s" % (hex(lo), run.hex(" ")))

    fixed_run = set_reg(run[0:6], 0x0A) + run[6:8] + set_reg(run[8:14], 0x0B) + run[14:16]
    print("        after : %s" % fixed_run.hex(" "))

    patched = dex[:lo] + fixed_run + dex[hi:]
    assert len(patched) == len(dex), "size changed"
    diff = [i for i in range(len(dex)) if dex[i] != patched[i]]
    print("bytes changed: %s" % [hex(x) for x in diff])
    assert diff == [lo + 4, lo + 12], [hex(x) for x in diff]

    patched = rehash(patched)
    if not header_ok(patched):
        print("ABORT: patched header invalid")
        return 3

    with zipfile.ZipFile(src) as zin, zipfile.ZipFile(out, "w") as zout:
        for item in zin.infolist():
            if item.filename.startswith("META-INF/") and (
                item.filename.endswith((".SF", ".RSA", ".DSA", ".EC"))
                or item.filename == "META-INF/MANIFEST.MF"
            ):
                continue
            data = patched if item.filename == "classes.dex" else zin.read(item.filename)
            zi = zipfile.ZipInfo(item.filename, date_time=item.date_time)
            zi.compress_type = item.compress_type
            zi.external_attr = item.external_attr
            zout.writestr(zi, data)

    with zipfile.ZipFile(out) as z:
        got = z.read("classes.dex")
        print("wrote %s entries=%d testzip=%s" % (out, len(z.infolist()), z.testzip()))
    if got != patched:
        print("ABORT: round-trip mismatch")
        return 4
    print("OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
