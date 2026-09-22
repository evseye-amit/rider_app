"""Re-tint the shared 3D artwork from the rendered violet to the brand pink.

Only the brand band moves. Hue is remapped onto a narrow band around the
logo's 317 degrees, saturation is scaled toward the logo's own, and value is
lifted along a curve that lightens without clipping the highlights — so the
shading that makes these read as rendered objects survives. Skin, hair and
every grey sit outside the band and are untouched.

  python3 tool/retint_art.py tool/art-violet assets/art
"""
from PIL import Image
import numpy as np
import sys, os, glob

SRC_LO, SRC_HI = 230.0, 310.0
DST_LO, DST_HI = 308.0, 326.0
SAT_SCALE = 0.62
VAL_LIFT = 0.30


def retint(path, out):
    im = Image.open(path).convert('RGBA')
    a = np.asarray(im).astype(np.float32) / 255.0
    rgb, alpha = a[..., :3], a[..., 3]
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    mx, mn = rgb.max(2), rgb.min(2)
    d = mx - mn
    dz = np.where(d == 0, 1.0, d)
    h = np.where(mx == r, ((g - b) / dz) % 6,
        np.where(mx == g, ((b - r) / dz) + 2, ((r - g) / dz) + 4)) * 60.0
    h = np.where(d == 0, 0.0, h) % 360.0
    s = np.where(mx == 0, 0.0, d / np.where(mx == 0, 1.0, mx))
    v = mx

    sel = (h >= SRC_LO) & (h <= SRC_HI) & (d > 0)
    h2 = np.where(sel, DST_LO + (h - SRC_LO) * (DST_HI - DST_LO) / (SRC_HI - SRC_LO), h)
    s2 = np.where(sel, s * SAT_SCALE, s)
    v2 = np.where(sel, v + (1.0 - v) * VAL_LIFT, v)

    i = np.floor(h2 / 60.0) % 6
    f = h2 / 60.0 - np.floor(h2 / 60.0)
    p, q, t = v2 * (1 - s2), v2 * (1 - f * s2), v2 * (1 - (1 - f) * s2)
    out_r = np.select([i==0,i==1,i==2,i==3,i==4,i==5], [v2,q,p,p,t,v2])
    out_g = np.select([i==0,i==1,i==2,i==3,i==4,i==5], [t,v2,v2,q,p,p])
    out_b = np.select([i==0,i==1,i==2,i==3,i==4,i==5], [p,p,t,v2,v2,q])
    res = np.dstack([out_r, out_g, out_b, alpha])
    res = np.clip(res * 255.0 + 0.5, 0, 255).astype(np.uint8)
    Image.fromarray(res).save(out, optimize=True)
    return sel.sum(), alpha.size


if __name__ == '__main__':
    src_dir, out_dir = sys.argv[1], sys.argv[2]
    os.makedirs(out_dir, exist_ok=True)
    for path in sorted(glob.glob(f'{src_dir}/*.png')):
        n, tot = retint(path, f'{out_dir}/{os.path.basename(path)}')
        print(f'  {os.path.basename(path):24} {100*n/tot:5.1f}% re-tinted')
