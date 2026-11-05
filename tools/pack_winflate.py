import zipfile, sys, os
src = r"<WORKSPACE>\archive\xueshen-mod9\wcls\classes.dex"
out = r"<WORKSPACE>\archive\xueshen-mod9\winflate.jar"
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    z.write(src, "classes.dex")
print("WROTE", out, os.path.getsize(out))
