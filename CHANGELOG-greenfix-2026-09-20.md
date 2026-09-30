# greenfix 变更说明（2026-09-20）

本 bundle 由 `import-bundle-2026-08-v5-chibi` 派生，**8 套 chibi 全部做了绿幕残留清理**。
原 bundle 一个字节未动。

## 修的是什么

不是"背景没抠"，而是两类残留（明细见 `greenfix-report.json`）：

1. **闭合镂空区漏抠** —— 被角色包围的负空间（发丝与脖子之间、呆毛环内、配饰缝隙）
   仍是整片纯绿。最严重的一处是 `grok-gothic-chibi-v1` 的 `failed` 行第 5 格，
   单块 **184 px**。
2. **轮廓半透明绿像素** —— 抗锯齿边缘保留绿幕混色，在浅色（金发）上表现为脏黄绿描边；
   各套合计 98–2,674 px。

## 修复前后（逐套）

| 套 | 偏绿像素 | 最大绿块 | 轮廓边缘绿 | 图集体积 | 20MiB 余量 |
|---|---|---|---|---|---|
| chatgpt-white-dragon-chibi-v5 | 1,272 → **0** | 63 → **0** | 0 → **0** | 2.89 MB | 85.5% |
| claude-orange-scholar-chibi-v3 | 98 → **0** | 7 → **0** | 0 → **0** | 1.91 MB | 90.4% |
| deepseek-whale-maid-chibi-v4 | 1,234 → **0** | 27 → **0** | 3 → **0** | 2.89 MB | 85.6% |
| gemini-star-cat-chibi-v1 | 791 → **0** | 17 → **0** | 0 → **0** | 2.86 MB | 85.7% |
| grok-gothic-chibi-v1 | 2,674 → **0** | **184 → 0** | 30 → **0** | 2.95 MB | 85.3% |
| kimi-moon-maid-chibi-v2 | 569 → **0** | 41 → **0** | 0 → **0** | 2.19 MB | 89.0% |
| qwen-chibi-scholar-v3 | 1,344 → **0** | 27 → **0** | 23 → **0** | 3.04 MB | 84.8% |
| zhipu-chibi-tech-v2 | 621 → **0** | 20 → **0** | 23 → **0** | 2.63 MB | 86.8% |

**损伤检查（硬门）**：`实心非绿像素被清 = 0`、`非绿像素改色 = 0`（8/8 通过）。
即修复只影响了偏绿像素，角色本体、轮廓、配色零改动。

## 本 bundle 里改了什么

| 文件 | 变更 |
|---|---|
| `<套>/spritesheet.webp` | **换入修复版**（`lossless=True, exact=True` 保存，逐像素无损） |
| `<套>/contact-sheet.png` | 按原版式重生成：768×1386，8×11 格，96×126/格，精灵 96×104 居中，底 #E8E8E8 |
| `<套>/qa/previews/*.gif`（9 个/套） | **新增**，由修复图集重生成；帧序取 `validation.json` 中 `used=true` 的单元格，帧时长沿用旧预览；解码后绿像素 = 0
  （⚠️ 2026-09-29 起已改：帧时长按 `animation-rows.md` **逐帧**生成 ✓；且新 `validation.json` 为官方摘要、
  不再含 `used` 字段 ✓——本行为当时流程记录 ✓） |
| `<套>/qa/previews/*.webp`（9 个/套） | **新增**，同帧序同时长，无损 + 完整 alpha（GIF 只有 1-bit 透明度，边缘易出硬边，建议优先用 WebP） |
| `<套>/validation.json` | （当时）追加 `green_residue_pixels` / `max_green_blob_px` / `fringe_green_pixels` / `green_residue_thresholds` / `green_residue_ok` / `greenfix{...}`；其余字段未动。<br>⚠️ **2026-09-29 起**该文件已改为官方 `validate_atlas.py` 摘要，**不再含上述 `green_*` 字段** ✓ |
| `greenfix-report.json` | 新增，逐套修复统计 |
| `CHANGELOG-greenfix-2026-09-20.md` | 本文件 |

未改动：`pet.json`、`dialogue.zh-CN.json`、`direction-semantics.json`、`visual-review.json`、
`blind-review-resolution.json`、各套 `README.md`。

## 验收方式

```bash
# ⚠️ 历史记录：下面两条路径来自当时本机的中间工作区，发布仓库中并不存在，
#    因此该命令**无法在本仓库原样复现** ✗；等价的可复现命令是本仓库自带的：
#      python3 tools/chroma-verify.py dist/codex-native dist/codex-standard-9row
PY=/opt/homebrew/opt/python@3.11/libexec/bin/python   # 当时的解释器路径（非通用）
$PY tools/chroma-verify.py "<当时的工作区A>" "<当时的工作区B>"
```

阈值：偏绿 ≤200 px、最大绿块 ≤20 px、边缘绿 ≤60 px、实心非绿被清 = 0、非绿改色 = 0。
退出码 0 = 通过（可直接接 CI）。工具说明见 `dist/SPEC.md` 第 5 节 ✓。

## 遗留 / 下一步

- 原 `validation.json` 只查"透明像素 RGB 残色"，这次新增的三个字段补上了"不透明偏绿像素"
  这个盲区 —— 建议把 `chroma-verify.py` 挂进生成流水线，避免这类回归再次出现。
- `qa/previews` 是本次按图集重生成的（旧预览在 `runs/2026-08-chibi-redo-v5/<套>/qa/previews/`，
  含绿残留，已不再使用）。
- 各套 `README.md` 里的旧数字未改（属历史记录）。

## 2026-09-29 — 契约合规修正（第二轮）

- **图集**：真问题是「完全透明像素带非零 RGB 残留」（官方校验器对原版即报错 ✗，各套 298–6400 px）；
  已把透明像素 RGB 置 0 ✓（可见像素逐位不变 ✓）。另**纠正一处自我误判** ✗：
  `idle` 行 `列6` 是官方 `EXTENDED_NEUTRAL_LOOK_FRAME`（v2 必须保留 ✗，v1 才是未用格 → 9row 清空 ✓）——
  曾被误当作未用格清掉，已回滚 ✓。**官方校验器 24/24 通过 ✓**
- **validation.json**：改用官方校验器重新生成（旧文件里的 `transparent_rgb_residue_pixels: 0` 与实测矛盾 ✗）。
  注：以上 `green_*` / `fringe_*` 字段名属于**旧版** `validation.json`；2026-09-29 起该文件为官方
  `validate_atlas.py` 摘要（`ok` / 尺寸 / 行列 / `transparent_rgb_residue_pixels`），不再含 `green_*` ✓
- **预览**：**顶层 144 个 + `dist/` 发布副本 144 个 = 288 个** GIF/WebP 按契约**逐帧时长**重生成（原来 9 状态是均一 duration ✗）；
  16 张接触表按原版式重做 ✓
- **派生**：16 个 zip 重建（结构/权限保持、内容与图集逐字节一致 ✓）；4 份报告用原判据重算 ✓
- **新增质量门**：`tools/check-contract.py`、`tools/verify-previews.py`、`tools/chroma-verify.py`
  （Python 3 + Pillow，非 0 退出码）✓
- **安装脚本**：改为 macOS 优先，兼容 Bash 3.2、零下载/零 sudo/零 Python，含只读预检与自动备份 ✓
- **文档**：新增 macOS 一行命令与 Windows「zip 手动添加」指南；客户端统一表述为 ChatGPT 应用 ✓
