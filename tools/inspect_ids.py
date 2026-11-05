import re, io, sys

p = r'archive/xueshen-mod9/mod9_src/res/values/public.xml'
s = io.open(p, encoding='utf-8').read()
ids = [int(m, 16) for m in re.findall(r'<public type="id" name="[^"]+" id="(0x7f[0-9a-f]+)"', s)]
print('count', len(ids))
print('max', hex(max(ids)))
print('tail', [hex(x) for x in sorted(ids)[-8:]])

# also report max per type prefix
from collections import defaultdict
d = defaultdict(list)
for m in re.finditer(r'<public type="([^"]+)" name="[^"]+" id="(0x7f[0-9a-f]+)"', s):
    d[m.group(1)].append(int(m.group(2), 16))
for t in sorted(d):
    print(t, 'n=%d' % len(d[t]), 'min', hex(min(d[t])), 'max', hex(max(d[t])))

# check ids.xml names not in public
i2 = io.open(r'archive/xueshen-mod9/mod9_src/res/values/ids.xml', encoding='utf-8').read()
names = re.findall(r'<item type="id" name="([^"]+)"', i2)
pub = set(re.findall(r'<public type="id" name="([^"]+)"', s))
missing = [n for n in names if n not in pub]
print('ids.xml count', len(names), 'not in public.xml:', missing[:20])
