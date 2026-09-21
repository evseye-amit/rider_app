"""Re-hue the shared 3D artwork from the old brand violet to the new pink.

Only the hue channel moves, and only inside the violet band; lightness and
saturation — the shading that makes these read as rendered objects rather
than flat icons — are untouched, as are skin, hair and every grey.
"""
from PIL import Image
import numpy as np
import sys, os, glob

SRC_LO, SRC_HI = 230.0, 310.0   # the violet band the art was rendered in
DST_LO, DST_HI = 300.0, 325.0   # the pink band, centred on the logo's 322

def rehue(path, out):
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
    h2 = np.where(sel,
                  DST_LO + (h - SRC_LO) * (DST_HI - DST_LO) / (SRC_HI - SRC_LO),
                  h)

    # HSV -> RGB
    i = np.floor(h2 / 60.0) % 6
    f = h2 / 60.0 - np.floor(h2 / 60.0)
    p, q, t = v * (1 - s), v * (1 - f * s), v * (1 - (1 - f) * s)
    out_r = np.select([i==0,i==1,i==2,i==3,i==4,i==5], [v,q,p,p,t,v])
    out_g = np.select([i==0,i==1,i==2,i==3,i==4,i==5], [t,v,v,q,p,p])
    out_b = np.select([i==0,i==1,i==2,i==3,i==4,i==5], [p,p,t,v,v,q])
    res = np.dstack([out_r, out_g, out_b, alpha])
    res = np.clip(res * 255.0 + 0.5, 0, 255).astype(np.uint8)
    Image.fromarray(res).save(out, optimize=True)
    return sel.sum(), alpha.size

if __name__ == '__main__':
    src_dir, out_dir = sys.argv[1], sys.argv[2]
    os.makedirs(out_dir, exist_ok=True)
    for p in sorted(glob.glob(f'{src_dir}/*.png')):
        n, tot = rehue(p, f'{out_dir}/{os.path.basename(p)}')
        print(f'  {os.path.basename(p):24} {100*n/tot:5.1f}% of pixels re-hued')
