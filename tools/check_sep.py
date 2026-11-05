import zipfile, sys, io

apk = r'<WORKSPACE>\archive\xueshen-mod9\mod9-preview-signed.apk'
z = zipfile.ZipFile(apk)
for name in z.namelist():
    if name.endswith('.dex'):
        d = z.read(name)
        # search for utf8 encoded " · " (space U+00B7 space) = 20 c2 b7 20
        pat = b'\x20\xc2\xb7\x20'
        lit = b' \\u00b7 '
        n_real = d.count(pat)
        n_lit = d.count(lit)
        if n_real or n_lit:
            print(name, 'real-UTF8-sep:', n_real, 'literal-backslash:', n_lit)
