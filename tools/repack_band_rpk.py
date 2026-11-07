#!/usr/bin/env python3
"""Repackage Xiaomi Band Vela QuickApp into .rpk file.

Usage:
    python3 repack_band_rpk.py [src_dir] [out_rpk]
"""
import os
import sys
import zipfile

def repack(src_dir="band_app", out_rpk="szpu_band_timetable_optimized.rpk"):
    base_dir = os.path.dirname(os.path.abspath(__file__))
    if not os.path.isabs(src_dir):
        src_dir = os.path.join(base_dir, src_dir)
    if not os.path.isabs(out_rpk):
        out_rpk = os.path.join(base_dir, out_rpk)

    print(f"Packaging {src_dir} -> {out_rpk} ...")
    with zipfile.ZipFile(out_rpk, "w", compression=zipfile.ZIP_DEFLATED) as z:
        for root, _, files in os.walk(src_dir):
            for f in files:
                full_path = os.path.join(root, f)
                arc_name = os.path.relpath(full_path, src_dir).replace("\\", "/")
                z.write(full_path, arc_name)
    print(f"Done! RPK size: {os.path.getsize(out_rpk)} bytes")

if __name__ == "__main__":
    src = sys.argv[1] if len(sys.argv) > 1 else "band_app"
    out = sys.argv[2] if len(sys.argv) > 2 else "szpu_band_timetable_optimized.rpk"
    repack(src, out)
