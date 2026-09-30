# AI 模型娘 · 桌面宠物包（Q 版 v5 · 适配 ChatGPT 应用）

> ### ⚡ 快速安装（English quick start）
> **macOS · 桌面应用（一行命令 ✓ 带 SHA-256 校验）** —— 见 §四 ⓪ ✓：校验发布包摘要后会装好 8 套到 `~/.codex/pets/` ✓ 覆盖前自动备份 ✓。
> **Windows · 桌面应用** —— 下载 ZIP ✓ 把 `dist\codex-native\<id>\` 整个文件夹复制到 `%USERPROFILE%\.codex\pets\<id>\` ✓ 然后 **设置 → Pets → Refresh** ✓。
> **ChatGPT 网页版宠物位** —— **不是复制文件夹** ✗：**Settings → Personalization → Pet → Upload pet** ✓ 上传单张透明 **1536 × 1872** 的 WebP ✓（`dist/codex-standard-9row/<id>/spritesheet.webp` ✓ ≤ 20 MiB ✓）。
> 每套都提供**两种版式** ✓：**v2 · 11 行 · 1536×2288**（桌面应用 ✓）与 **v1 · 9 行 · 1536×1872**（网页版 / 只认 v1 的客户端 ✓）。

> ## 🎨 这是什么
> **面向各家 AI 品牌的「社区同人形象创作」** —— 由社区作者以各品牌的公开形象、配色与调性为灵感，
> 独立设计的 8 套 Q 版拟人桌宠（每套对应一家），并打包成 Codex 可用的宠物格式。
> 均为**非官方同人创作**：与 OpenAI / Anthropic / Google / xAI / DeepSeek / Moonshot / 阿里 / 智谱
> **无任何关联**，未获授权、赞助或背书，**不代表其官方形象或立场**；角色名中的品牌词**仅作识别用途**。
> 详见 [`NOTICE.md`](NOTICE.md)。
>
> ## 🤖 关于 AI 生成
> **本仓库全部角色美术均由 AI 图像生成模型产出**，随后由人工处理：逐格可用性校验、视觉复核，
> 以及绿幕残留清理（偏绿像素 → 透明，含轮廓边缘；硬门数字见 `chroma-verify.json`）。
> 画面因此带有生成式图像的常见特征：细节偶有不一致、相邻帧有轻微抖动、手脚等部位偶有失真。
> 台词、id / 名称、校验与复核记录为人工编写或人工判定。
>
> English: [README.en.md](README.en.md) · 发布前核验报告：[`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md)

## 一、角色一览（下为各套 `idle.gif` 实拍动图）

| # | id（= 安装目录名） | 名称 | 设定 | 预览 |
|---|---|---|---|---|
| 1 | `chatgpt-white-dragon-chibi-v5` | ChatGPT 白发龙娘 Q 版 | 银白长发龙娘，灰色龙角、白色实体龙尾 | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="88" alt="idle"> |
| 2 | `claude-orange-scholar-chibi-v3` | Claude 橙书娘 Q 版 | 橙发书卷少女，奶油橙黑学者裙与随身书本 | <img src="claude-orange-scholar-chibi-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 3 | `deepseek-whale-maid-chibi-v4` | DeepSeek 蓝鲸女仆 Q 版 | 蓝发鲸鱼女仆，向上弯曲的实体鲸尾、白围裙 | <img src="deepseek-whale-maid-chibi-v4/qa/previews/idle.gif" width="88" alt="idle"> |
| 4 | `gemini-star-cat-chibi-v1` | Gemini 星猫娘 Q 版 | 紫蓝渐变长发，异色瞳与四角星饰 | <img src="gemini-star-cat-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 5 | `grok-gothic-chibi-v1` | Grok 暗金哥特娘 Q 版 | 金发双马尾，角冠与蝙蝠纹样 | <img src="grok-gothic-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 6 | `kimi-moon-maid-chibi-v2` | Kimi 月影娘 Q 版 | 银白长发，黑灰与淡紫层叠礼服 | <img src="kimi-moon-maid-chibi-v2/qa/previews/idle.gif" width="88" alt="idle"> |
| 7 | `qwen-chibi-scholar-v3` | Qwen 蓝发学者娘 Q 版 | 靛蓝中式长裙、折扇与珠穗 | <img src="qwen-chibi-scholar-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 8 | `zhipu-chibi-tech-v2` | 智谱 珊瑚技术娘 Q 版 | 珊瑚橙发，白贝雷帽与格纹裙、工具包 | <img src="zhipu-chibi-tech-v2/qa/previews/idle.gif" width="88" alt="idle"> |

### 9 个标准状态动图图例（以 ①ChatGPT 白发龙娘 为例）

| `idle` 待机 | `running-right` 右移 | `running-left` 左移 | `waving` 挥手 |
|---|---|---|---|
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-right.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-left.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waving.gif" width="96"> |
| **`jumping` 跳跃** | **`failed` 失败** | **`waiting` 等待** | **`review` 审查** |
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/jumping.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/failed.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waiting.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/review.gif" width="96"> |

> `running`（工作中）动图：<img src="chatgpt-white-dragon-chibi-v5/qa/previews/running.gif" width="88" alt="running">
> 每套宠物在自己的 `<id>/qa/previews/` 下都有这 9 个 GIF（另有 WebP 版：无损、带完整 alpha，优先用）。

## 二、“Codex v2 宠物图集规格”是什么

**一句话**：它是 **Codex「自定义宠物」要求的图集契约** —— 官方**不通过网页文档发布** ✗，
而是写在**随 Codex 一起分发的 `hatch-pet` 技能**里（OpenAI 策展插件 `work-pets` 下发 ✓）：

```text
${CODEX_HOME:-$HOME/.codex}/skills/hatch-pet/references/codex-pet-contract.md   # 标题：Codex V2 Pet Contract
${CODEX_HOME:-$HOME/.codex}/skills/hatch-pet/references/animation-rows.md       # 逐行状态、用到第几列、帧时长
```

> 本仓库的规格描述即以此契约为准；若两者不一致，**以你本机该文件为准** ✓。

### v2 与 v1 的差别（关键，装错会解析错位）

| 项 | **v2**（本仓库主产物） | **v1** |
|---|---|---|
| `spriteVersionNumber` | **`2`** | **省略该字段**（缺省即 v1） |
| 图集尺寸 | **1536 × 2288** | **1536 × 1872** |
| 行数 | **11**（9 标准状态 + 2 注视方向） | 9 |
| 单格 / 列数 | 192 × 208 / **8 列** | 同 |
| 背景 | 透明；**未用到的格子必须全透明** | 同 |

⚠️ 契约的两条硬性规定：

1. **8×9 的 1536×1872 只是中间装配产物 —— “不要把它当作新宠物打包”**。
2. `spriteVersionNumber` **漏写会退回 v1**，此时 **2288 高的图集会被直接拒绝**；反之，**声明 v2 却给 1872 的图集同样会解析错位**。

⇒ 所以本仓库的 `dist/codex-standard-9row/` 是给**只认 v1 的客户端**准备的 **v1 版式** ✓，
它的 `pet.json` **不带** `spriteVersionNumber` ✓ —— 请不要把那两份文件混进 Codex 的 v2 宠物流程 ✗。

### 行序（0 起）

| 行 | 状态 | 用到的列 | 说明 |
|---|---|---|---|
| 0 | `idle` | 0–5；扩展中性帧列 6 | 待机（也是"减弱动态"时的首帧） |
| 1 | `running-right` | 0–7 | 向右移动 |
| 2 | `running-left` | 0–7 | 向左移动（镜像需保证道具/身份不反） |
| 3 | `waving` | 0–3 | 挥手 / 引起注意 |
| 4 | `jumping` | 0–4 | 跳跃 / 悬停反馈 |
| 5 | `failed` | 0–7 | 失败 / 沮丧反应 |
| 6 | `waiting` | 0–5 | 等待你的输入或批准 |
| 7 | `running` | 0–5 | 正在干活（非字面跑动） |
| 8 | `review` | 0–5 | 审查产出 |
| 9 | 注视方向 A | 0–7 | `000°`→`157.5°`，每帧 22.5° |
| 10 | 注视方向 B | 0–7 | `180°`→`337.5°`，每帧 22.5° |

- **`000°` = 正上方（12 点方向），不是正面** ✓；正面属于「无方向死区」，回落到 `idle` ✓。
- 每行**帧时长**、以及"未用列必须全透明"等细则见上面那份 `animation-rows.md` ✓。
- 本套 8 只宠物均为 **8×11 母版** ✓，第 9–10 行的注视方向齐全（16 向）✓。

### `pet.json` 字段（v2）

```json
{
  "id": "chatgpt-white-dragon-chibi-v5",
  "displayName": "ChatGPT 白发龙娘 Q 版",
  "description": "一句话说明（本仓库各套均含「非官方同人宠物」字样）",
  "spriteVersionNumber": 2,
  "spritesheetPath": "spritesheet.webp"
}
```

- `id`：小写 + 连字符 slug，**必须与安装目录名完全一致** ✓
- `spritesheetPath`：包内相对路径 ✓（与 `pet.json` 同层 ✓）
- 安装位置：`${CODEX_HOME:-$HOME/.codex}/pets/<id>/{pet.json,spritesheet.webp}` ✓

## 三、本仓库的图集规格

| 项 | 值 |
|---|---|
| 单格 | **192 × 208** px |
| 列 × 行 | **8 × 11** = 1536 × 2288（v2 主产物，母版） |
| 另一版式 | **8 × 9** = 1536 × 1872（**v1**，给只认 v1 的客户端；见 §二） |
| 格式 | WebP，**透明背景**，`lossless=True, exact=True`（逐像素无损） |
| 体积 | 1.68 – 3.01 MiB／套（本项目自设上限 20 MiB，余量 84.9%+） |

## 四、安装引导

> **关于客户端**：原 **Codex 桌面应用**已被 **ChatGPT 应用**取代（2026-09 **单机实测**所得 ✓；
> 仓库内无自证材料，未获独立验证 ✗）。
> 自定义宠物目录仍是 `~/.codex/pets/<id>/` ✓ —— 由 ChatGPT 应用读取 ✓（该目录规则来自应用随包下发的
> `hatch-pet` 技能契约 `${CODEX_HOME:-$HOME/.codex}/pets/<pet-name>/` ✓）。本仓库的安装说明据此只针对
> **ChatGPT 应用** ✓。

### ⓪ macOS：一行命令装好（复制粘贴到「终端」即可）

```bash
V=v1.0.0; SHA=5868c80d48e505f0bb50b5b222d0523c7a169d2cdbb167be1590333a1aa5a9ca
d="${TMPDIR:-/tmp}/pets-install"; mkdir -p "$d" && cd "$d" \
 && curl -fL -C - --retry 3 --retry-all-errors -o pets.tar.gz \
    "https://gh-proxy.com/https://github.com/fywdy/chatgpt-chibi-pets/releases/download/$V/codex-pets-install-$V.tar.gz" \
 && echo "$SHA  pets.tar.gz" | shasum -a 256 -c - \
 && tar xzf pets.tar.gz && bash "codex-pets-install-$V/dist/install-codex.sh" native
```

> **固定版本 + 摘要校验** ✓：下载的是 Release 资产 `v1.0.0`（不是会变的 `main` 归档 ✗），
> 且**先校验 SHA-256、通过了才会执行** ✓ —— 校验和不符会在此停下，不会运行任何脚本 ✓。
> 该校验和同时写在仓库 `dist/SHA256SUMS` ✓（与 tag `v1.0.0` 一一对应 ✓，可自行比对 ✓）。
> 链接用了 `gh-proxy.com` 镜像 ✓（国内直连 GitHub 常只有几十 KB/s ✗，本机实测镜像可达 ~2 MB/s ✓）；
> 网络不好时**再执行同一行即可续传** ✓（`-C -` 接着上次的字节继续 ✓）；想走官方源删掉 `https://gh-proxy.com/` 前缀 ✓；
> 若本机代理反而更慢，给 `curl` 加 `--noproxy '*'` **绕开系统代理**再走镜像 ✓
> （本机实测：绕开 104 KB/s ↔ 走代理 87 KB/s，视线路而定 ✓ 两种都可直接粘贴 ✓）。

- 只用 **macOS 自带**的 `curl` / `tar` / `bash` ✓ —— **不用装任何东西，也不需要 Python** ✗
  （脚本的校验走系统自带 `plutil` ✓，图集尺寸由脚本内部解析 ✓）
- 这是**桌面应用**的装法 ✓（网页版**不用**装文件夹 ✗，见 §① 的「网页版」小节 ✓）
- 装到 `~/.codex/pets/` ✓，**覆盖前自动备份** ✓；装完按提示重启 ChatGPT 应用 → **设置 → Pets → Refresh** ✓
- 回滚：把 `~/.codex/pets_backup-<时间戳>/<id>/` 拷回 `~/.codex/pets/` ✓
- 想先空跑：在命令末尾把 `native` 换成 `--help` 看用法，或先加 `CODEX_HOME=/tmp/cx_test` 试装到临时目录 ✓
- 已 clone 过仓库的话，等价命令是：`bash dist/install-codex.sh native` ✓

### ① Windows：下载 zip 后手动添加（不需要命令行）

1. **下载**：打开仓库页 → 绿色 **Code** 按钮 → **Download ZIP**
   （直接链接：`https://github.com/fywdy/chatgpt-chibi-pets/archive/refs/heads/main.zip`）
2. **解压** zip，进入 `chatgpt-chibi-pets-main\dist\` —— 里面有两个可用目录，**按你要装到哪个应用来选**：

   | 装到哪 | 用哪个目录 | 图集 |
   |---|---|---|
   | **ChatGPT 桌面应用**（原 Codex 桌面端已并入） | `dist\codex-native\` | v2，8×11，1536×2288 ✓ |
   | **ChatGPT 网页版宠物位** | `dist\codex-standard-9row\` | v1，8×9，1536×1872 ✓（该宠物位只认这一种尺寸） |

   ⚠️ **网页版和桌面版的装法完全不同** ✗（官方说明：桌面端本地宠物**不会**同步到网页 ✗）：
   - **桌面应用**（macOS/Windows）＝ 上面这个「复制到 `.codex\pets\` + Refresh」流程 ✓，用 `dist\codex-native\`（v2）✓
   - **网页版**＝ **不需要复制文件夹** ✗：打开 ChatGPT 网页版 → **Settings → Personalization → Pet → Upload pet** ✓
     上传**单张**透明 PNG/WebP ✓ 必须**正好 1536×1872** ✓ 且 ≤ 20 MiB ✓ ⇒ 用 `dist\codex-standard-9row\<id>\spritesheet.webp` ✓
     （网页版宠物只在支持的 Work 会话里出现 ✓ 没有桌面端的浮窗/活动托盘/`/pet` ✓；是否可用取决于账号与工作区 ✓）

3. **复制整套文件夹**到宠物目录 —— 在资源管理器地址栏粘贴：
   ```
   %USERPROFILE%\.codex\pets
   ```
   没有 `pets` 文件夹就自己新建一个。把选的整套（例如 `chatgpt-white-dragon-chibi-v5`）连文件夹一起放进去 ✓
   最终结构必须是（**两个文件同层，且文件夹名 = `pet.json` 里的 `id`**）：
   ```
   %USERPROFILE%\.codex\pets\chatgpt-white-dragon-chibi-v5\pet.json
   %USERPROFILE%\.codex\pets\chatgpt-white-dragon-chibi-v5\spritesheet.webp
   ```
   8 套要全装就把 8 个文件夹都放进去 ✓
4. **刷新列表**：打开 **ChatGPT 应用** → **设置（Settings）→ Pets → 点 Refresh** ✓
   自定义宠物列表里就会出现新加的这几套 ✓ 选中即可显示 ✓
5. 注意三点 ✓：① 文件夹名与 `pet.json` 里的 `id` **必须完全一致** ✓；② 两个文件**必须同层** ✓；
   ③ 别把 `codex-standard-9row\` 那份装进 ChatGPT 应用 ✗、也别把 `codex-native\` 那份喂给只认 v1 的 ChatGPT 宠物位 ✗

> 装错了想重来：直接删掉 `%USERPROFILE%\.codex\pets\<id>` 文件夹即可 ✓（此目录只放宠物素材 ✓）

### ② ChatGPT 应用（脚本方式，含备份与回滚）

```bash
# 在本仓库根目录执行
bash dist/install-codex.sh native     # 11 行 v2 母版（1536×2288）——装进 ChatGPT 应用 用这个
```

脚本做三件事：把 8 套的 `pet.json` + `spritesheet.webp` 复制到 `~/.codex/pets/<id>/`；
**覆盖前先自动备份**已存在的同名宠物到 `~/.codex/pets_backup-<时间戳>/`；逐套打印 `✓ <id>`。

安装完成后：打开 **ChatGPT 应用 → 设置（Settings）→ Pets → 点 Refresh**，自定义宠物列表里就会出现这 8 个 ✓。

- 换安装位置：`CODEX_HOME=/自定义/路径 bash dist/install-codex.sh native`
- 只装某一套：手动复制 `dist/codex-native/<id>/{pet.json,spritesheet.webp}` 到 `~/.codex/pets/<id>/`
- **卸载 / 回滚**：删掉 `~/.codex/pets/<id>/`；想回到覆盖前的版本，把
  `~/.codex/pets_backup-<时间戳>/<id>/` 拷回 `~/.codex/pets/`

### ③ 只认 v1（1536×1872）的客户端（含 ChatGPT 网页版宠物位）

用 `dist/codex-standard-9row/<id>/` ✓（其 `pet.json` **不带** `spriteVersionNumber` ✓ = v1 ✓）：
**桌面 / 第三方客户端**用该目录里那两份文件（`pet.json` + `spritesheet.webp`）✓；
**ChatGPT 网页版只上传其中的 `spritesheet.webp` 一张** ✗（不传 `pet.json` ✓，走 Settings → Personalization → Pet → Upload pet ✓）。
**不要**把 11 行 v2 母版喂给它们 ✗，也不要把这份 9 行版装进 ChatGPT 应用 ✗（见 §二的两条硬性规定）。

### ④ 第三方桌宠客户端

不同客户端对 zip 内的层级要求不一致，所以**两种都产出了**（zip 内是 **v2 / 11 行** 版 ✓）：

| 客户端 | 用哪份 | 操作 |
|---|---|---|
| **clawd-on-desk** | `dist/import-packages/<id>.zip`（被拒再试 `<id>-foldered.zip`） | 设置 → 主题 → 导入宠物 zip |
| **CoPet** | 同上 zip | 导入宠物包 |
| **Petdex** | `dist/codex-standard-9row/<id>/` 或 native | 格式与本套一致，可直接投稿 / `npx petdex install` |

先试根层版；若导入器报「找不到 `pet.json`」，换**文件夹版**（`*-foldered.zip`）再试一次 ✓。

### ⑤ 任意能读图片的客户端 / 播放器

用 `dist/generic-assets/<id>/`：接触表 `contact-sheet.png` + `previews/`（9 个状态各一份 GIF + 一份 WebP）✓。

> **优先用 `.webp` 预览**：GIF 只有 1 bit 透明度，边缘容易出硬边；WebP 版无损且带完整 alpha ✓。

### ⑥ 常见问题

- **列表里看不到宠物** ⇒ 目录名与 `pet.json` 的 `id` 是否**完全一致**、`spritesheet.webp` 是否与 `pet.json` **同层**，
  然后重启 ChatGPT 应用 / 重新 Refresh ✓。
- **图集尺寸/帧错位报错** ⇒ 大概率是 **v1 版式配了 v2 声明**（或反之）✗ —— 对照 §二 的表换用正确的组合 ✓。
- **角色边缘有绿边** ⇒ 本套已过绿幕硬门（残留 0）✓；你看到绿边多半是客户端把透明区按**黑底**合成所致 ✓，
  换支持 alpha 的客户端，或直接看 `previews/*.webp` ✓。
- **想自己改** ⇒ 替换 `dist/codex-native/<id>/` 那两份文件即可 ✓；**v2 请保留 `spriteVersionNumber: 2`** ✓。

### ⑦ 脚本行为与安全说明（可自行核对）

`dist/install-codex.sh` 是**纯本地脚本：不联网、不用 sudo、不删除任何文件** ✓，只做「只读预检 → 备份 → 复制」：

1. **只读预检**（任一套不合规 ⇒ **整体中止，不改动任何文件** ✗）：逐套检查
   `spritesheet.webp` 存在且为 WebP（RIFF/WEBP 魔数 ✓）、体积在 100000 字节（≈97.7 KiB）–20 MiB 之间 ✓、
   `pet.json` 的 `id` 与目录名一致 ✓、包内版本声明与所选变体一致 ✓、
   以及**要覆盖的已装版本若版式不同则默认拒绝** ✗（防 v1/v2 交错覆盖；确认要换版式加 `--force` ✓）。
2. **备份**：只把将被覆盖的同名目录整体备份到 `${CODEX_HOME}/pets_backup-<时间戳>/` ✓。
3. **复制**：仅写 `${CODEX_HOME:-$HOME/.codex}/pets/<id>/{pet.json,spritesheet.webp}` ✓，完成后打印 sha256 前 16 位供你比对 ✓。

**建议先空跑核对**（装到临时目录，完全不碰你的 Codex ✓）：

```bash
CODEX_HOME=/tmp/cx_test bash dist/install-codex.sh native
```

## 五、质量门（逐套复核）

| 门 | 阈值 | 实测 |
|---|---|---|
| 不透明偏绿像素 | ≤ 200 | **0**（8/8） |
| 最大绿块 | ≤ 20 px | **0**（8/8） |
| 轮廓边缘绿 | ≤ 60 px | **0**（8/8） |
| **实心非绿像素被清** | **= 0** | **0**（8/8） |
| **非绿像素改色** | **= 0** | **0**（8/8） |

即修复**只影响了偏绿像素**：角色本体、轮廓与配色零改动 ✓。
逐套数字见 `greenfix-report.json`、`chroma-verify.json` 与
[`CHANGELOG-greenfix-2026-09-20.md`](CHANGELOG-greenfix-2026-09-20.md)；
公开发布前的脱敏与规格核验见 [`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md) ✓。

## 六、目录结构

```
<id>/                         # 母版素材与记录
  pet.json                    # v2：id / displayName / description / spriteVersionNumber:2 / spritesheetPath
  spritesheet.webp            # 8×11 = 1536×2288，透明
  dialogue.zh-CN.json         # 中文人格台词
  validation.json             # 官方校验器摘要（ok / 尺寸 / 行列 / 透明像素 RGB 残留；不含逐格数组）
  visual-review.json          # 视觉复核记录
  contact-sheet.png           # 768×1386 接触表
  qa/previews/*.gif|*.webp    # 9 个状态预览（README 图例即取自此）
  direction-semantics.json    # 仅 claude / grok / kimi 三套有
  blind-review-resolution.json  # 仅上述三套有
  README.md
dist/
  codex-native/<id>/          # v2：pet.json + 11 行 1536×2288（装进 ChatGPT 应用用这个）
  codex-standard-9row/<id>/   # v1：pet.json（不带 spriteVersionNumber）+ 9 行 1536×1872
  generic-assets/<id>/        # 接触表 + 预览
  import-packages/<id>.zip            # v2 根层版
  import-packages/<id>-foldered.zip   # v2 文件夹版
  install-codex.sh  SPEC.md  dist-report.json  import-packages-report.json
tools/
  check-contract.py   verify-previews.py   chroma-verify.py   # 仓库自带质量门（用法见 §五）
CHANGELOG-greenfix-2026-09-20.md   chroma-verify.json   greenfix-report.json
docs/README-bundle-original.md
NOTICE.md   LICENSE   LICENSE-MIT   RELEASE-REPORT-2026-09-27.md
```

## 七、许可与再利用

| 部分 | 许可 |
|---|---|
| 角色图集、接触表、预览图（**AI 生成 + 人工修复**的美术资产） | **CC BY-NC 4.0**（署名 · **禁止商用**）见 [`LICENSE`](LICENSE) |
| `install-codex.sh` 等脚本与 JSON 工具产物 | **MIT** 见 [`LICENSE-MIT`](LICENSE-MIT) |

欢迎在**保留 [`NOTICE.md`](NOTICE.md)** 与**非商用**的前提下二次创作、改色、做成自己的宠物包 ✓。
角色名中的品牌词仅为识别用途，相关商标归各自所有者 ✓；如权利人认为不妥，请在 Issues 提出，我们会及时下架 ✓。

## 八、来源与致谢

- **Codex v2 宠物格式**：以随 Codex 分发的 `hatch-pet` 技能内的 `codex-pet-contract.md`（*Codex V2 Pet Contract*）
  与 `animation-rows.md` 为准 ✓（OpenAI 策展插件 `work-pets` 下发 ✓）。本仓库据此产出并自检 ✓。
- 8 套角色为**社区同人形象创作** ✓，由本仓库作者使用 AI 图像生成 + 人工逐格校验/修复流程制作 ✓。
- 客户端支持情况（Codex / ChatGPT 网页版 / Petdex / clawd-on-desk / CoPet）为 2026-09-20 实测与查证 ✓，
  完整矩阵与「为什么不支持某客户端」见 [`dist/SPEC.md`](dist/SPEC.md) ✓。
