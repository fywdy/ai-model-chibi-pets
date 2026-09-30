#!/usr/bin/env python3
"""预览契约合规检查：9 个状态的帧数与逐帧时长必须与 animation-rows.md 一致。

用法:  python3 tools/verify-previews.py [仓库根目录]
退出码: 0 = 全部一致；1 = 有缺失或不一致（详细列出）。
仅依赖 Pillow。
"""
import os
import sys

from PIL import Image

# 状态 → 各帧时长（ms），取自 Codex V2 契约 animation-rows.md
CONTRACT = {
    'idle':          [280, 110, 110, 140, 140, 320],
    'running-right': [120] * 7 + [220],
    'running-left':  [120] * 7 + [220],
    'waving':        [140] * 3 + [280],
    'jumping':       [140] * 4 + [280],
    'failed':        [140] * 7 + [240],
    'waiting':       [150] * 5 + [260],
    'running':       [120] * 5 + [220],
    'review':        [150] * 5 + [280],
}


def preview_dirs(root):
    out = []
    for dirpath, dirnames, files in os.walk(root):
        if '.git' in dirpath.split(os.sep):
            continue
        if os.path.basename(dirpath) == 'previews' and any(f.endswith('.gif') for f in files):
            out.append(dirpath)
    return sorted(out)


def durations(path):
    im = Image.open(path)
    d = []
    for i in range(getattr(im, 'n_frames', 1)):
        im.seek(i)
        d.append(im.info.get('duration'))
    return im.size, d


def webp_durations(path):
    """WebP 的逐帧时长：Pillow 的 info['duration'] 只给首帧，故直接解析 ANMF 块。"""
    data = open(path, 'rb').read()
    out, i = [], 0
    while True:
        j = data.find(b'ANMF', i)
        if j < 0:
            break
        # ANMF 载荷：x(3) y(3) w-1(3) h-1(3) duration(3) flags(1)
        out.append(int.from_bytes(data[j + 20:j + 23], 'little'))
        i = j + 4
    return out


def main():
    root = sys.argv[1] if len(sys.argv) > 1 else '.'
    dirs = preview_dirs(root)
    if not dirs:
        print(f"✗ 在 {root} 下没有找到任何 previews 目录")
        return 1
    bad = 0
    checked = 0
    for d in dirs:
        probs = []
        for state, exp in CONTRACT.items():
            for ext in ('.gif', '.webp'):
                p = os.path.join(d, state + ext)
                if not os.path.exists(p):
                    probs.append(f"缺 {state}{ext}")
                    continue
                size, got = durations(p)
                if ext == '.webp':
                    n = getattr(Image.open(p), 'n_frames', 1)
                    if n != len(exp):
                        probs.append(f"{state}.webp 帧数 {n} ≠ {len(exp)}")
                    if size != (192, 208):
                        probs.append(f"{state}.webp 尺寸 {size} ≠ (192, 208)")
                    wd = webp_durations(p)
                    if len(wd) != len(exp) or wd != exp:
                        probs.append(f"{state}.webp 时长 {wd} ≠ {exp}")
                    continue
                if size != (192, 208):
                    probs.append(f"{state}.gif 尺寸 {size} ≠ (192, 208)")
                if len(got) != len(exp) or got != exp:
                    probs.append(f"{state}.gif 时长 {got} ≠ {exp}")
        checked += 1
        rel = os.path.relpath(d, root)
        if probs:
            bad += len(probs)
            print(f"✗ {rel}")
            for p in probs:
                print(f"    - {p}")
        else:
            print(f"✓ {rel}  9 状态帧数与逐帧时长全部符合契约")
    print(f"\n共检查 {checked} 个预览目录；问题 {bad} 项")
    return 0 if bad == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
