import io, re, sys

p = r'<WORKSPACE>\archive\xueshen-mod9\WidgetPreviewActivity.java'
s = io.open(p, encoding='utf-8').read()
for m in re.finditer(u'".{0,20}"', s):
    t = m.group(0)
    if any(ord(c) > 127 for c in t):
        cps = [(c, hex(ord(c))) for c in t if ord(c) > 127]
        print(repr(t))
        print('   ', cps[:12])
