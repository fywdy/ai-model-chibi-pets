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
| v1 尺寸 | **1536 × 1872**（8 × 9）—— **只是中间装配产物**，供只认 v1 的客户端使用 |
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
| `codex-native/<套>/` | `pet.json`（**v2**，`spriteVersionNumber: 2`）+ **11 行** 1536×2288 | Codex 桌面版 / CLI |
| `codex-standard-9row/<套>/` | `pet.json`（**v1**，**省略** `spriteVersionNumber`）+ **8×9** 1536×1872 | 只认 v1 的客户端（ChatGPT 网页版等）；**不要装进 Codex** ✗ |
| `generic-assets/<套>/` | `pet.json` + `contact-sheet.png` + `previews/*.gif` + `previews/*.webp` | 任何能读图片的客户端 / 播放器 |
| `import-packages/<套>.zip` | `pet.json` + `spritesheet.webp`（根层） | 第三方桌宠客户端「导入宠物包」 |
| `import-packages/<套>-foldered.zip` | 同上，但在 `<套>/` 子目录内 | 要求 zip 内带文件夹的导入器 |

`import-packages/` 两种层级都产出了：不同导入器对 zip 内层级要求不一致，
先试根层版（`<套>.zip`），被拒再试文件夹版。

## 4. 客户端支持矩阵（2026-09-20 实测/查证）

### ✅ 可直接使用

| 客户端 | 覆盖的 Agent | 做法 |
|---|---|---|
| **Codex 桌面版 / CLI** | Codex | 原生支持 `~/.codex/pets/<id>/`；用 `codex-native/`，`bash dist/install-codex.sh` 安装 |
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

## 5. 质量门

```bash
PY=/opt/homebrew/opt/python@3.11/libexec/bin/python
$PY tools/chroma-verify.py <原bundle> <修复后bundle>     # 退出码 0/1，可接 CI
```

阈值：偏绿像素 ≤200、最大绿块 ≤20 px、轮廓边缘绿 ≤60 px、
**实心非绿像素被清 = 0**、**非绿像素改色 = 0**。

## 6. 版权与署名

8 套角色为**面向各家 AI 品牌的社区同人形象创作**（非官方同人），与 OpenAI / Anthropic / Google / xAI /
DeepSeek / Moonshot / 阿里 / 智谱**无任何关联**，未获授权、赞助或背书，也**不代表其官方形象或立场**；
角色名中的品牌词仅作**识别用途**。

本仓库采取的策略：**保留品牌前缀** + `NOTICE.md`（非官方 / 无关联 / 商标归各自所有者 / 下架承诺）
+ 美术 **CC BY-NC 4.0**（非商用）+ 脚本 **MIT**。若权利人认为不妥，在 Issues 提出即下架。
