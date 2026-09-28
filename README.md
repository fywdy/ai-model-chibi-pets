# AI 模型娘 · Codex 桌面宠物包（Q 版 v5）

> ## 🤖 关于 AI 生成
> **本仓库全部角色美术均由 AI 图像生成模型产出**，随后由人工处理：逐格可用性校验、视觉复核，
> 以及绿幕残留清理（偏绿像素 → 透明，含轮廓边缘；硬门数字见 `chroma-verify.json`）。
> 画面因此带有生成式图像的常见特征：细节偶有不一致、相邻帧有轻微抖动、手脚等部位偶有失真。
> 台词、id / 名称、校验与复核记录为人工编写或人工判定。
>
> ⚠️ **非官方同人创作**：与 OpenAI / Anthropic / Google / xAI / DeepSeek / Moonshot / 阿里 / 智谱
> **无任何关联**，未获授权或背书；角色名中的品牌词**仅作识别用途**。详见 [`NOTICE.md`](NOTICE.md)。
>
> English: [README.en.md](README.en.md) · 发布前核验报告：[RELEASE-REPORT-2026-09-27.md](RELEASE-REPORT-2026-09-27.md)

8 套 Q 版桌宠，适配 **Codex v2 宠物图集规格**（`pet.json` + `spritesheet.webp`）。
每套含 **9 行官方状态动画 + 2 行扩展注视方向**、中文人格台词、逐格校验与视觉复核记录。

## 一、角色一览

| # | id（= 安装目录名） | 名称 | 设定 |
|---|---|---|---|
| 1 | `chatgpt-white-dragon-chibi-v5` | ChatGPT 白发龙娘 Q 版 | 银白长发龙娘，灰色龙角、白色实体龙尾 |
| 2 | `claude-orange-scholar-chibi-v3` | Claude 橙书娘 Q 版 | 橙发书卷少女，奶油橙黑学者裙与随身书本 |
| 3 | `deepseek-whale-maid-chibi-v4` | DeepSeek 蓝鲸女仆 Q 版 | 蓝发鲸鱼女仆，向上弯曲的实体鲸尾、白围裙 |
| 4 | `gemini-star-cat-chibi-v1` | Gemini 星猫娘 Q 版 | 紫蓝渐变长发，异色瞳与四角星饰 |
| 5 | `grok-gothic-chibi-v1` | Grok 暗金哥特娘 Q 版 | 金发双马尾，角冠与蝙蝠纹样 |
| 6 | `kimi-moon-maid-chibi-v2` | Kimi 月影娘 Q 版 | 银白长发，黑灰与淡紫层叠礼服 |
| 7 | `qwen-chibi-scholar-v3` | Qwen 蓝发学者娘 Q 版 | 靛蓝中式长裙、折扇与珠穗 |
| 8 | `zhipu-chibi-tech-v2` | 智谱 珊瑚技术娘 Q 版 | 珊瑚橙发，白贝雷帽与格纹裙、工具包 |

## 二、图集规格

| 项 | 值 |
|---|---|
| 单格 | **192 × 208** px |
| 列 × 行 | **8 × 11**（母版 1536 × 2288）／**8 × 9**（官方标准 1536 × 1872） |
| 格式 | WebP，**透明背景**，`lossless=True, exact=True`（逐像素无损） |
| 体积 | 1.68 – 3.04 MiB／套（Codex 上限 20 MiB，余量 85%+） |
| 行序 | 0 `idle` · 1 `running-right` · 2 `running-left` · 3 `waving` · 4 `jumping` · 5 `failed` · 6 `waiting` · 7 `running` · 8 `review` · 9–10 **扩展注视方向**（每帧 45°，共 16 向） |

> 行 9–10 为本套自扩展，**不在官方标准内**；只取前 9 行的客户端不受影响。

## 三、安装引导（中文）

### ① Codex 桌面版 / CLI —— 推荐

```bash
# 在本仓库根目录执行
bash dist/install-codex.sh native     # 11 行母版（1536×2288）
# 或
bash dist/install-codex.sh 9row       # 官方 9 行版（1536×1872）
```

脚本会做三件事：把 8 套的 `pet.json` + `spritesheet.webp` 复制到 `~/.codex/pets/<id>/`；
**覆盖前先自动备份**已存在的同名宠物到 `~/.codex/pets_backup-<时间戳>/`；逐套打印 `✓ <id>`。

安装完成后：打开 **Codex 桌面版 → 设置（Settings）→ Pets → 点 Refresh**，
自定义宠物列表里就会出现这 8 个，选中即可。

- 换安装位置：`CODEX_HOME=/自定义/路径 bash dist/install-codex.sh native`
- 只装某一套：手动复制 `dist/codex-native/<id>/{pet.json,spritesheet.webp}` 到 `~/.codex/pets/<id>/` 即可
- **卸载 / 回滚**：删掉 `~/.codex/pets/<id>/` 即可；想回到覆盖前的版本，把
  `~/.codex/pets_backup-<时间戳>/<id>/` 拷回 `~/.codex/pets/`

### ② ChatGPT 网页版宠物

网页版**只认 1536×1872（8×9）**，请使用 `dist/codex-standard-9row/<id>/` 里的**那两份文件**，
不要用母版 11 行图集（多出的两行会让尺寸校验失败）。

### ③ 第三方桌宠客户端

不同客户端对 zip 内的层级要求不一致，所以**两种都产出了**：

| 客户端 | 用哪份 | 操作 |
|---|---|---|
| **clawd-on-desk** | `dist/import-packages/<id>.zip`（被拒再试 `<id>-foldered.zip`） | 设置 → 主题 → 导入宠物 zip |
| **CoPet** | 同上 zip | 导入宠物包 |
| **Petdex** | `dist/codex-standard-9row/<id>/` 或 natives | 格式与本套一致，可直接投稿 / `npx petdex install` |

先试根层版；若导入器报「找不到 `pet.json`」，就换**文件夹版**（`*-foldered.zip`）再试一次。

### ④ 任意能读图片的客户端 / 播放器

用 `dist/generic-assets/<id>/`：里面是接触表 `contact-sheet.png` 与
`previews/`（9 个状态各一份 GIF + 一份 WebP）。

> **优先用 `.webp` 预览**：GIF 只有 1 bit 透明度，边缘容易出硬边；WebP 版无损且带完整 alpha。

### ⑤ 常见问题

- **列表里看不到宠物** ⇒ 确认目录名与 `pet.json` 的 `id` **完全一致**，且 `spritesheet.webp`
  与 `pet.json` **在同一层**，然后重启 Codex / 重新 Refresh。
- **图集尺寸报错** ⇒ 你用的可能是 11 行母版但客户端只认官方 9 行，换 `codex-standard-9row/`。
- **角色边缘有绿边** ⇒ 本套已过绿幕硬门（残留 0）；若你看到绿边，多半是客户端把透明区按**黑底**
  合成所致，换用支持 alpha 的客户端或 `previews/*.webp`。
- **想自己改** ⇒ 直接用 `dist/codex-native/<id>/` 那两份文件替换即可；`pet.json` 里
  `spriteVersionNumber` 必须保持 `2`。

## 四、质量门（逐套复核）

| 门 | 阈值 | 实测 |
|---|---|---|
| 不透明偏绿像素 | ≤ 200 | **0**（8/8） |
| 最大绿块 | ≤ 20 px | **0**（8/8） |
| 轮廓边缘绿 | ≤ 60 px | **0**（8/8） |
| **实心非绿像素被清** | **= 0** | **0**（8/8） |
| **非绿像素改色** | **= 0** | **0**（8/8） |

即修复**只影响了偏绿像素**：角色本体、轮廓与配色零改动。
逐套修复前后数字见 `greenfix-report.json`、`chroma-verify.json` 与
[`CHANGELOG-greenfix-2026-09-20.md`](CHANGELOG-greenfix-2026-09-20.md)；
公开发布前的脱敏与规格核验见 [`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md)。

## 五、目录结构

```
<id>/                         # 母版素材与记录
  pet.json                    # id / displayName / description / spriteVersionNumber:2 / spritesheetPath
  spritesheet.webp            # 8×11 = 1536×2288，透明
  dialogue.zh-CN.json         # 中文人格台词
  validation.json             # 逐格校验（含绿幕残留字段）
  visual-review.json          # 视觉复核记录
  contact-sheet.png           # 768×1386 接触表
  qa/previews/*.gif|*.webp    # 9 个状态预览
  README.md
dist/
  codex-native/<id>/          # pet.json + 11 行图集（Codex 原生）
  codex-standard-9row/<id>/   # pet.json + 9 行 1536×1872
  generic-assets/<id>/        # 接触表 + 预览
  import-packages/<id>.zip    # 根层版
  import-packages/<id>-foldered.zip
  install-codex.sh  SPEC.md  dist-report.json  import-packages-report.json
CHANGELOG-greenfix-2026-09-20.md   chroma-verify.json   greenfix-report.json
docs/README-bundle-original.md
NOTICE.md   LICENSE   LICENSE-MIT   RELEASE-REPORT-2026-09-27.md
```

## 六、许可与再利用

| 部分 | 许可 |
|---|---|
| 角色图集、接触表、预览图（**AI 生成 + 人工修复**的美术资产） | **CC BY-NC 4.0**（署名 · **禁止商用**）见 [`LICENSE`](LICENSE) |
| `install-codex.sh` 等脚本与 JSON 工具产物 | **MIT** 见 [`LICENSE-MIT`](LICENSE-MIT) |

欢迎在**保留 [`NOTICE.md`](NOTICE.md)** 与**非商用**的前提下二次创作、改色、做成自己的宠物包。
角色名中的品牌词仅为识别用途，相关商标归各自所有者；如权利人认为不妥，请在 Issues 提出，我们会及时下架。

## 七、致谢与来源

- 图集规格与行序参考 Codex 自定义宠物（v2）格式及其社区文档。
- 8 套角色为本仓库作者使用 AI 图像生成 + 人工修复流程制作。
- 客户端支持情况（Codex / ChatGPT 网页版 / Petdex / clawd-on-desk / CoPet）为 2026-09-20 实测与查证，
  完整矩阵与「为什么不支持某客户端」见 [`dist/SPEC.md`](dist/SPEC.md)。
