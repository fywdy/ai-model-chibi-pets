#!/usr/bin/env python3
"""图集契约合规检查：每行未用格必须完全透明（Codex V2 Pet Contract / animation-rows.md）。

用法:  python3 tools/check-contract.py [仓库根目录]
退出码: 0 = 全部合规；1 = 存在越界未用格（详细列出）。
仅依赖 Pillow。
"""
import os
import sys

from PIL import Image, ImageChops

CW, CH = 192, 208
# 依据官方校验器 validate_atlas.py：
#   v2（11 行）：idle 行列 0–6 全部 used —— 其中 (0,6) 是 EXTENDED_NEUTRAL_LOOK_FRAME（扩展中性注视帧）✓
#   v1（9 行） ：无注视行，故 (0,6) 属未用格，必须完全透明 ✗
USED_V2 = {0: [0, 1, 2, 3, 4, 5, 6], 1: list(range(8)), 2: list(range(8)), 3: [0, 1, 2, 3],
           4: [0, 1, 2, 3, 4], 5: list(range(8)), 6: [0, 1, 2, 3, 4, 5],
           7: [0, 1, 2, 3, 4, 5], 8: [0, 1, 2, 3, 4, 5], 9: list(range(8)), 10: list(range(8))}
USED_V1 = {0: [0, 1, 2, 3, 4, 5], 1: list(range(8)), 2: list(range(8)), 3: [0, 1, 2, 3],
           4: [0, 1, 2, 3, 4], 5: list(range(8)), 6: [0, 1, 2, 3, 4, 5],
           7: [0, 1, 2, 3, 4, 5], 8: [0, 1, 2, 3, 4, 5]}


def used_map(rows):
    """按行数选择 v1 / v2 的 used 表。"""
    return USED_V2 if rows >= 11 else USED_V1


def find_sheets(root):
    out = []
    for dirpath, dirnames, files in os.walk(root):
        if '.git' in dirpath.split(os.sep):
            continue
        if 'spritesheet.webp' in files:
            out.append(os.path.join(dirpath, 'spritesheet.webp'))
    return sorted(out)


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else '.'
    files = find_sheets(root)
    if not files:
        print(f"✗ 在 {root} 下没有找到任何 spritesheet.webp")
        return 1
    bad_total = 0
    for f in files:
        im = Image.open(f).convert('RGBA')
        w, h = im.size
        cols, rows = w // CW, h // CH
        problems = []
        if w % CW or h % CH:
            problems.append(f"尺寸 {w}x{h} 不是 {CW}x{CH} 的整数倍")
        table = used_map(rows)
        kind = 'v2(11 行)' if rows >= 11 else f'v1({rows} 行)'
        for r in range(rows):
            used = table.get(r)
            if used is None:
                problems.append(f"出现契约未定义的第 {r} 行")
                continue
            for c in range(cols):
                if c in used:
                    continue
                cell = im.crop((c * CW, r * CH, (c + 1) * CW, (r + 1) * CH))
                alpha = cell.getchannel('A').tobytes()
                nz = sum(1 for v in alpha if v != 0)
                if nz:
                    problems.append(f"未用格 行{r}列{c} 有 {nz} 个不透明像素")
        # 官方校验器的 residue 规则：完全透明像素的 RGB 必须为 0
        r_ch, g_ch, b_ch, a_ch = im.split()
        transparent = a_ch.point(lambda v: 255 if v == 0 else 0)
        nonzero_rgb = ImageChops.lighter(ImageChops.lighter(r_ch, g_ch), b_ch).point(
            lambda v: 255 if v > 0 else 0)
        residue = ImageChops.multiply(transparent, nonzero_rgb).histogram()[255]
        if residue:
            problems.append(f"有 {residue} 个完全透明像素带非零 RGB 残留（官方校验器会报错）")
        rel = os.path.relpath(f, root)
        if problems:
            bad_total += len(problems)
            print(f"✗ {rel}  {w}x{h} {cols}列x{rows}行 [{kind}]")
            for p in problems:
                print(f"    - {p}")
        else:
            print(f"✓ {rel}  {w}x{h} {cols}列x{rows}行 [{kind}]  未用格全透明")
    print(f"\n共检查 {len(files)} 张图集；越界问题 {bad_total} 项")
    return 0 if bad_total == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
