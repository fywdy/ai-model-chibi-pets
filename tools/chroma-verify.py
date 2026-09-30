#!/usr/bin/env python3
"""绿幕残留质量门：与历史报告同判据（a>0 且 g>90 且 g-max(r,b)>40 记为偏绿像素）。

用法:  python3 tools/chroma-verify.py [仓库根目录]
阈值: 偏绿像素 ≤ 200、最大连通绿块 ≤ 20 px、轮廓边缘绿 ≤ 60 px
退出码: 0 = 全部通过；1 = 有超阈值项。
仅依赖 Pillow（无需 numpy）。
"""
import os
import sys

from PIL import Image, ImageChops

MAX_GREEN_PX = 200
MAX_BLOB_PX = 20
MAX_FRINGE_PX = 60


def green_mask(im):
    """返回 'L' 模式掩码：255 = 判为偏绿像素。"""
    r, g, b, a = im.convert('RGBA').split()
    g_hi = g.point(lambda v: 255 if v > 90 else 0)
    diff = ImageChops.subtract(g, ImageChops.lighter(r, b))          # g - max(r,b)，负值截断为 0
    diff_ok = diff.point(lambda v: 255 if v > 40 else 0)
    opaque = a.point(lambda v: 255 if v > 0 else 0)
    return ImageChops.multiply(ImageChops.multiply(g_hi, diff_ok), opaque)


def max_blob(mask):
    """最大 8 邻域连通块大小。绿像素通常为 0，故按行扫描仅收集有效像素。"""
    w, h = mask.size
    pts = set()
    for y in range(h):
        row = mask.crop((0, y, w, y + 1)).tobytes()
        start = -1
        while True:
            start = row.find(b'\xff', start + 1)
            if start < 0:
                break
            pts.add((y, start))
    best = 0
    while pts:
        seed = pts.pop()
        stack = [seed]
        size = 0
        while stack:
            y, x = stack.pop()
            size += 1
            for dy in (-1, 0, 1):
                for dx in (-1, 0, 1):
                    q = (y + dy, x + dx)
                    if q in pts:
                        pts.discard(q)
                        stack.append(q)
        best = max(best, size)
    return best


def fringe_px(im, mask):
    """偏绿且 4 邻域内存在完全透明像素的计数。"""
    a = im.convert('RGBA').split()[3]
    trans = a.point(lambda v: 255 if v == 0 else 0)
    w, h = mask.size
    total = 0
    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
        sh = ImageChops.offset(trans, dx, dy)
        # 去掉 offset 造成的环绕边
        if dx:
            edge = (w - 1, 0, w, h) if dx > 0 else (0, 0, 1, h)
            sh.paste(0, edge)
        if dy:
            edge = (0, h - 1, w, h) if dy > 0 else (0, 0, w, 1)
            sh.paste(0, edge)
        total += ImageChops.multiply(mask, sh).histogram()[255]
    return total


def check(root):
    sheets = []
    for dirpath, dirnames, files in os.walk(os.path.join(root, 'codex-native')):
        if 'spritesheet.webp' in files:
            sheets.append(os.path.join(dirpath, 'spritesheet.webp'))
    if not sheets:
        for dirpath, dirnames, files in os.walk(root):
            if '.git' in dirpath.split(os.sep):
                continue
            if 'spritesheet.webp' in files:
                sheets.append(os.path.join(dirpath, 'spritesheet.webp'))
    if not sheets:
        print(f"✗ 在 {root} 下没有找到任何 spritesheet.webp")
        return 1
    failed = 0
    for s in sorted(sheets):
        im = Image.open(s).convert('RGBA')
        mask = green_mask(im)
        n = mask.histogram()[255]
        blob = max_blob(mask)
        fr = fringe_px(im, mask)
        ok = n <= MAX_GREEN_PX and blob <= MAX_BLOB_PX and fr <= MAX_FRINGE_PX
        rel = os.path.relpath(s, root)
        mark = '✓' if ok else '✗'
        print(f"{mark} {rel:66s} 偏绿 {n:5d}  最大绿块 {blob:3d}  边缘绿 {fr:3d}")
        if not ok:
            failed += 1
    print(f"\n阈值：偏绿 ≤{MAX_GREEN_PX}、最大绿块 ≤{MAX_BLOB_PX}、边缘绿 ≤{MAX_FRINGE_PX}；"
          f"检查 {len(sheets)} 张，超阈值 {failed} 张")
    return 0 if failed == 0 else 1


def main():
    rc = 0
    for root in (sys.argv[1:] or ['.']):    # 支持传入多个目录，逐个检查
        rc |= check(root)
    return rc


if __name__ == '__main__':
    sys.exit(main())
