# 规格与适配说明（SPEC）

本 bundle 的 8 套宠物来自同一套母版图集，附带多种可直接使用的形态。
所有图集均为**透明背景、逐像素无损 WebP**，已通过绿幕残留验证门（`chroma-verify.py`）。

> **规格来源（v2 契约）**：本文件描述的规格以**随 Codex 分发**的 `hatch-pet` 技能内的
> `references/codex-pet-contract.md`（*Codex V2 Pet Contract*）与 `references/animation-rows.md` 为准
> （经 OpenAI 策展插件 `work-pets` 下发）。本地路径：
> `${CODEX_HOME:-$HOME/.codex}/skills/hatch-pet/references/`。**若两者不一致，以本机该文件为准**。

## 1. 图集规格

| 项 | 值 |
|---|---|
| 单格 | **192 × 208** px |
| 列数 | **8**（每行 8 帧） |
| 行数 | **11**（**v2 契约**：9 个标准状态行 + 2 个注视方向行 —— 两者都是 v2 的一部分） |
| 尺寸 | **1536 × 2288**（8 列 × 11 行） |
| v1 尺寸 | **1536 × 1872**（8 × 9）—— **发布产物之一**（v1 规范），供只认 v1 的客户端使用 |
| 格式 | WebP，透明背景，`lossless=True, exact=True` |
| 体积 | 1.9–3.0 MB／套（本项目自设 ≤ 20 MiB；契约文件未规定上限） |

### 行序（0 起）

| 行 | 状态 | 说明 |
|---|---|---|
| 0 | `idle` | 待机 |
| 1 | `running-right` | 向右移动 |
| 2 | `running-left` | 向左移动 |
| 3 | `waving` | 挥手 |
| 4 | `jumping` | 跳跃 / 悬停反馈 |
| 5 | `failed` | 失败反应 |
| 6 | `waiting` | 等待输入 |
| 7 | `running` | 工作中 |
| 8 | `review` | 审查 / 检查 |
| 9 | `look-000~157.5` | 注视方向 A（8 帧，每帧 **22.5°**） |
| 10 | `look-180~337.5` | 注视方向 B（8 帧，每帧 **22.5°**） |

> 行 9–10 **属于 v2 契约本身**（16 个顺时针注视方向）；`000°` 指**正上方**（12 点），**不是正面** ——
> 正面是无向量死区，回落到 `idle`。每行用到的列与帧时长见 `animation-rows.md`。

### 每行用到的列、帧时长与未用格（契约硬要求）

| 行 | 状态 | 用到的列 | 各帧时长（ms） |
|---|---|---|---|
| 0 | `idle` | **0–5**（6 帧动画）+ **列 6**（扩展中性注视帧，被使用 ✓） | 280, 110, 110, 140, 140, 320 |
| 1 | `running-right` | 0–7 | 120 ×7，末帧 220 |
| 2 | `running-left` | 0–7 | 120 ×7，末帧 220 |
| 3 | `waving` | **0–3** | 140 ×3，末帧 280 |
| 4 | `jumping` | **0–4** | 140 ×4，末帧 280 |
| 5 | `failed` | 0–7 | 140 ×7，末帧 240 |
| 6 | `waiting` | **0–5** | 150 ×5，末帧 260 |
| 7 | `running` | **0–5** | 120 ×5，末帧 220 |
| 8 | `review` | **0–5** | 150 ×5，末帧 280 |
| 9 | `look A` | 0–7 | 每帧 22.5° |
| 10 | `look B` | 0–7 | 每帧 22.5° |

**未用格必须完全透明**（契约原文：*Unused cells after each standard animation row's final used column
must be fully transparent.*）⇒ 本规格的硬性检查项（**以官方校验器 `validate_atlas.py` 的内部定义为准** ✓）：

- 未用格 = 行 0 的列 **7**、行 3 的列 **4–7**、行 4 的列 **5–7**、行 6/7/8 的列 **6–7**（每张共 **14 格**）
- ⚠️ **行 0 的列 6 不是未用格** ✓ —— 它是官方 `EXTENDED_NEUTRAL_LOOK_FRAME = (0, 6)`，即「扩展中性注视帧」，
  属于**被使用**的格 ✓（校验器把 idle 行列 0–6 全部标为 `used: true` ✓）。把它清空会被判
  `idle row 0 column 6 is empty or too sparse` ✗
- 行 1/2/5/9/10 **全部 8 列都用到**，不存在未用格
- 另一条硬性要求：**完全透明的像素其 RGB 必须为 0** ✓（不得有 RGB 残留 ✗，否则官方校验器报
  `atlas has N fully transparent pixels with non-zero RGB residue` ✓）

#### 本仓库的合规修正记录（2026-09）

实际的合规问题与修正过程（含一次**自我纠正** ✓，记录在案以免后人重蹈）：

| 阶段 | 内容 | 结论 |
|---|---|---|
| 误判 ✗ | 初读 `animation-rows.md` 文字条款（"unused cells … must be fully transparent"）时，把 `idle` 的列 6 当成了未用格，于是**清空了 24 张图集的该格** | **错误** ✗ —— 官方校验器立即报 `idle row 0 column 6 is empty or too sparse` |
| 自我纠正 ✓ | 读官方校验器源码，确认 `EXTENDED_NEUTRAL_LOOK_FRAME = (0, 6)`，即该格是**被使用的扩展中性注视帧**；随即把 24 张图集**回滚**到修改前 ✓ | 结论：**只按文字条款推断是不够的，必须以官方校验器为准** ✓ |
| 真问题 ✓ | 官方校验器在**修改前**就报 `atlas has N fully transparent pixels with non-zero RGB residue`（各套 298–6400 px ✗）—— 即完全透明像素仍带着非零 RGB | 这才是需要修的真问题 ✓ |
| 正确修正 ✓ | v2（11 行）**保留** `(0,6)` 的扩展中性注视帧、**不动其像素** ✗；v1（9 行）**清空** `(0,6)`（v1 下该格未用 ✓）；同时把**完全透明像素的 RGB 置 0** ✓（可见像素逐位不变 ✓） | **官方校验器 24/24 通过 ✓，残留全 0 ✓** |
| 关键认知 ✓ | **v1 与 v2 对 `(0,6)` 的要求完全相反** —— v2 必须有内容（`EXTENDED_NEUTRAL_LOOK_FRAME`），v1 必须全透明（无注视行的语境下它是未用格）✗ | 只按文字条款或不区分版本，两个方向都会错 ✗ |
| 附带 | 旧的 `validation.json` 曾写着 `transparent_rgb_residue_pixels: 0` ✗ —— 与官方校验器的实测（298–6400 ✗）矛盾，属**报告数据不实** ✓ | 现已改用官方校验器重新生成 ✓（并把其输出里的绝对路径改写为仓库内相对路径 ✓） |

> **预览（GIF/WebP）的时长**以本表为准 ✓。修正前 9 个状态的预览时长是**均一值**（生成脚本误抄了旧
> GIF 的单一 `duration` ✗），现已按上表逐帧重生成 ✓ —— 用 `tools/verify-previews.py` 可复现校验 ✓。
> 另：GIF 调色板量化会把少数**边界像素**推过绿幕判据（源像素 `g-max(r,b)` 恰为 40–43 ✗），
> 故预览生成时对 `g-max(r,b) > 25` 的边界像素预先下压至 25（共约 2839 px、占比 <0.01% ✓ 视觉不可见 ✓）；
> **图集母版不做此类调整** ✗。

## 2. `pet.json` 字段

```json
{
  "id": "grok-gothic-chibi-v1",
  "displayName": "Grok 暗金哥特娘 Q 版",
  "description": "…（含“非官方同人宠物”声明）",
  "spriteVersionNumber": 2,
  "spritesheetPath": "spritesheet.webp"
}
```

- `id`：小写 + 连字符 slug，须与安装目录名一致
- `spriteVersionNumber`：**v2 写 `2`；v1 必须省略该字段**（缺省即 v1）。**错配会被拒或帧错位** ✗
- `spritesheetPath`：包内相对路径（与 `pet.json` 同层）

## 3. 产物目录

| 目录 | 内容 | 用途 |
|---|---|---|
| `codex-native/<套>/` | `pet.json`（**v2**，`spriteVersionNumber: 2`）+ **11 行** 1536×2288 | ChatGPT 应用（原 Codex 桌面端已并入） |
| `codex-standard-9row/<套>/` | `pet.json`（**v1**，**省略** `spriteVersionNumber`）+ **8×9** 1536×1872 | 只认 v1 的客户端（ChatGPT 网页版等）；**不要装进 ChatGPT 应用** ✗ |
| `generic-assets/<套>/` | `pet.json` + `contact-sheet.png` + `previews/*.gif` + `previews/*.webp` | 任何能读图片的客户端 / 播放器 |
| `import-packages/<套>.zip` | `pet.json` + `spritesheet.webp`（根层） | 第三方桌宠客户端「导入宠物包」 |
| `import-packages/<套>-foldered.zip` | 同上，但在 `<套>/` 子目录内 | 要求 zip 内带文件夹的导入器 |

`import-packages/` 两种层级都产出了：不同导入器对 zip 内层级要求不一致，
先试根层版（`<套>.zip`），被拒再试文件夹版。

## 4. 客户端支持矩阵（2026-09-20 实测/查证）

> ⚠️ **来源与局限**：下表是关于第三方客户端的信息来自当时的外部查证与**单机实测** ✓，
> **仓库内没有可自证的材料** ✗ —— 独立审核已将本表列为「未能验证」项 ✓。请读者以各客户端当时的
> 官方说明为准；本仓库只保证 `dist/` 产物本身的规格与合规 ✓。

### ✅ 可直接使用

| 客户端 | 覆盖的 Agent | 做法 |
|---|---|---|
| **ChatGPT 应用** | ChatGPT（已并入原 Codex 桌面端） | 原生支持 `~/.codex/pets/<id>/`（已在本机实测确认）；用 `codex-native/`，`bash dist/install-codex.sh` 安装 |
| **ChatGPT 网页版宠物** | ChatGPT | 支持但**只认 1536×1872（8×9）**；用 `codex-standard-9row/` |
| **Petdex** | Codex / Claude Code / DeepSeek Harness / Hermes / OpenCode / Gemini CLI 等 | 官方宠物包格式就是 **`pet.json` + `spritesheet.{webp,png}`，8×9 或 v2 8×11，单格 192×208** —— 与本套完全一致，可**直接投稿图库**；另有 CLI（`npx petdex install`）与桌面 App（目前仅 macOS） |
| **clawd-on-desk** | Claude Code / Codex / Cursor / Copilot CLI / Gemini / Antigravity / Qwen / OpenClaw 等 | 支持导入 Codex 宠物包：`设置 → 主题 → 导入宠物 zip`，会自动把图集转成托管主题；用 `import-packages/` 里的 zip |
| **CoPet** | Claude Code / Codex / Antigravity / OpenCode / Cursor / Copilot CLI / Pi / Gemini | 「内置宠物 + 支持导入 Codex 兼容宠物包」；用 `import-packages/` 里的 zip |

### ⚠️ 需要额外开发

| 客户端 | 情况 |
|---|---|
| **VS Code / Cursor / Windsurf / VSCodium** | 流行的 `vscode-pets` 扩展**没有自定义宠物格式**（其 README 与官方文档均无此项），只能内置类型。要支持需自行写扩展读本规格图集 |
| **Shimeji-ee**（经典桌宠框架） | 素材格式公开：`img/<角色>/shime*.png`（默认 46 张、128×128）+ `conf/actions.xml` + `behaviors.xml`。**可写转换脚本**把本图集映射成 idle/walk/fall/drag/sit 等动作，但需人工校对动作语义 |
| **Clyde**（clawd-on-desk 的 fork） | 渲染层用 SVG 而非位图图集，导入支持情况未确认，需实测 |

### ❌ 不支持（形态限制）

| 客户端 | 原因 |
|---|---|
| **Claude Code / Gemini CLI / Qwen Code / Kimi CLI 等终端 CLI** | 终端形态无位图宠物位；除 Codex CLI 支持 iTerm2/Kitty/Sixel 图形外，其余只能做 ASCII/真彩块动画 |
| **Desktop Mate 等 3D 桌宠** | 需要 VRM 三维模型，不是位图图集 |

## 5. 质量门（仓库自带脚本，可自行复现）

```bash
python3 tools/check-contract.py .          # 图集契约合规：未用格必须全透明（本仓库目标：0 越界）
python3 tools/verify-previews.py .         # 预览契约合规：9 状态帧数与逐帧时长必须与上表一致
python3 tools/chroma-verify.py dist        # 绿幕残留门：偏绿像素 ≤200、最大绿块 ≤20 px、轮廓边缘绿 ≤60 px
```

三个脚本都只用 **Python 3 + Pillow**（无需 numpy），失败时以**非 0 退出码**结束，可直接接 CI ✓。
`chroma-verify.py` 的判据与历史报告一致：`a>0 且 g>90 且 g-max(r,b)>40` 记为「偏绿像素」。
历史报告另记录两项：**实心非绿像素被清 = 0**、**非绿像素改色 = 0**。

## 6. 版权与署名

8 套角色为**面向各家 AI 品牌的社区同人形象创作**（非官方同人），与 OpenAI / Anthropic / Google / xAI /
DeepSeek / Moonshot / 阿里 / 智谱**无任何关联**，未获授权、赞助或背书，也**不代表其官方形象或立场**；
角色名中的品牌词仅作**识别用途**。

本仓库采取的策略：**保留品牌前缀** + `NOTICE.md`（非官方 / 无关联 / 商标归各自所有者 / 下架承诺）
+ 美术 **CC BY-NC 4.0**（非商用）+ 脚本 **MIT**。若权利人认为不妥，在 Issues 提出即下架。
