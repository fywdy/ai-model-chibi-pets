# 8 套 AI 模型娘 Q 版桌宠（适配 ChatGPT 应用）

基于社区创作的 AI 模型娘形象，做成了 8 套 ChatGPT 应用能直接用的 Q 版桌宠。

它们会在你聊天时待在窗口里：干活时跑动、等你输入时眨眼、出错时蔫掉。

- **8 套**，每套 9 个状态 + 16 个注视方向的动画
- 宠物图集由我用 AI 图像模型生成，之后逐格检查、修掉绿幕残留与不合格的格子
- **社区同人作品**，与品牌方无关联 —— 详见 [`NOTICE.md`](NOTICE.md)

**快速安装**：[macOS 桌面应用](#macos-桌面应用) ｜ [Windows 桌面应用](#windows-桌面应用) ｜ [ChatGPT 网页版](#chatgpt-网页版)

> **English**: see [`README.en.md`](README.en.md)

---

## 一、8 套角色

下图为各角色的待机动画。

| # | 名称 | 预览 |
|---|---|---|
| 1 | ChatGPT 白发龙娘 Q 版 | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="88" alt="idle"> |
| 2 | Claude 橙书娘 Q 版 | <img src="claude-orange-scholar-chibi-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 3 | DeepSeek 蓝鲸女仆 Q 版 | <img src="deepseek-whale-maid-chibi-v4/qa/previews/idle.gif" width="88" alt="idle"> |
| 4 | Gemini 星猫娘 Q 版 | <img src="gemini-star-cat-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 5 | Grok 暗金哥特娘 Q 版 | <img src="grok-gothic-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 6 | Kimi 月影娘 Q 版 | <img src="kimi-moon-maid-chibi-v2/qa/previews/idle.gif" width="88" alt="idle"> |
| 7 | Qwen 蓝发学者娘 Q 版 | <img src="qwen-chibi-scholar-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 8 | 智谱 珊瑚技术娘 Q 版 | <img src="zhipu-chibi-tech-v2/qa/previews/idle.gif" width="88" alt="idle"> |

各角色的安装目录名见下方[名称与目录名对照](#名称与目录名对照)。

### 动画预览（部分状态，以 ① 白发龙娘为例）

| `idle` 待机 | `running-right` 右移 | `running-left` 左移 | `waving` 挥手 |
|---|---|---|---|
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-right.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-left.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waving.gif" width="96"> |
| **`jumping` 跳跃** | **`failed` 失败** | **`waiting` 等待你** | **`review` 审查** |
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/jumping.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/failed.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waiting.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/review.gif" width="96"> |

每个角色目录的 `qa/previews/` 里都有全套 9 个状态的 GIF/WebP，可以单独查看。

---

## 二、怎么装

**先记住一件事：有两种版式，装错会错位。**

| 版式 | 尺寸 | 给谁用 | 在哪个目录 |
|---|---|---|---|
| **v2 · 11 行** | 1536 × 2288 | **ChatGPT 桌面应用**（macOS / Windows） | `dist/codex-native/<id>/` |
| **v1 · 9 行** | 1536 × 1872 | **ChatGPT 网页版宠物位**、只认 v1 的客户端 | `dist/codex-standard-9row/<id>/` |

### macOS 桌面应用

复制**整段命令**，粘贴到「终端」：

```bash
V=v1.0.0; SHA=5868c80d48e505f0bb50b5b222d0523c7a169d2cdbb167be1590333a1aa5a9ca
d="${TMPDIR:-/tmp}/pets-install"; mkdir -p "$d" && cd "$d" \
 && curl -fL -C - --retry 3 --retry-all-errors -o pets.tar.gz \
    "https://gh-proxy.com/https://github.com/fywdy/chatgpt-chibi-pets/releases/download/$V/codex-pets-install-$V.tar.gz" \
 && echo "$SHA  pets.tar.gz" | shasum -a 256 -c - \
 && tar xzf pets.tar.gz && bash "codex-pets-install-$V/dist/install-codex.sh" native
```

它会先校验下载包的 SHA-256（不符就停下，不执行任何脚本），再解包，把 8 套装进 `~/.codex/pets/`，覆盖前自动备份。装完按提示重启应用，然后 **设置 → Pets → Refresh** 选中宠物；再输入 `/pet`，或在命令菜单里选择 **Show pet**，桌宠就会显示出来。

> 用的是固定版本 tag + `gh-proxy` 镜像；校验和也写在仓库 `dist/SHA256SUMS`，可自行比对。
> 网络慢时**再执行同一段命令**即可续传（`-C -`）；镜像慢可以给 curl 加 `--noproxy '*'` 绕开系统代理。
> 装到别处：先执行 `export CODEX_HOME="/你的路径"`，再运行安装命令。默认安装到 `~/.codex/pets/`，备份目录默认是同级 `pets_backup-<时间戳>/`；设了 `CODEX_HOME` 后，安装与备份路径都跟着它变。
> 想回滚：把 `~/.codex/pets_backup-<时间戳>/<id>/` 拷回去。

### Windows 桌面应用

1. 仓库页 → 绿色 **Code** → **Download ZIP** → 解压。
2. 把 `dist\codex-native\<某个 id>\` **整个文件夹**复制到 `%USERPROFILE%\.codex\pets\`（注意是 `pets\` 这一层父目录）。没有 `pets` 文件夹就先建一个。复制完成后，文件应当位于：
   ```
   %USERPROFILE%\.codex\pets\<id>\pet.json
   %USERPROFILE%\.codex\pets\<id>\spritesheet.webp
   ```
   8 套都要就复制 8 个文件夹。
3. 打开 **ChatGPT 应用 → 设置（Settings）→ Pets → Refresh**，选中即可。选中后输入 `/pet`，或在命令菜单里选择 **Show pet**，桌宠就会显示出来。

> 文件夹名必须与 `pet.json` 里的 `id` **完全一致**，且 `pet.json` 与 `spritesheet.webp` **必须在同一层**。
> 想删掉某套：直接删 `%USERPROFILE%\.codex\pets\<id>\` 文件夹（这里只放宠物素材）。

### ChatGPT 网页版

网页版**不是复制文件夹**，而是上传一张图。

1. 先从仓库页 → **Code** → **Download ZIP** 下载并解压，才有下面那个文件。
2. 打开 ChatGPT 网页版 → **Settings → Personalization → Pet**（Pet 入口是否出现，取决于你的账户与工作区是否已开放该功能；网页宠物显示在支持的 ChatGPT Work 对话里）。
3. 点 **Upload pet**，选这张图（透明背景 · 正好 1536 × 1872 · ≤ 20 MiB）：
   ```
   dist/codex-standard-9row/<id>/spritesheet.webp
   ```
4. 保存后即可选用。

> 网页版只认 **1536 × 1872（9 行版）**，别传 11 行的那份。
> 桌面端装在本地 `~/.codex/pets/` 的宠物**不会**自动同步到网页版，两边要各自装一次。

### 其他客户端

| 客户端 | 用哪份 | 怎么用 |
|---|---|---|
| **clawd-on-desk** | `dist/import-packages/<id>.zip`（被拒就试 `<id>-foldered.zip`） | 设置 → 主题 → 导入宠物 zip |
| **CoPet** | 同上 | 导入宠物包 |
| **Petdex** | `dist/codex-standard-9row/<id>/` 或 `codex-native` | 投稿本地资源：`npx petdex submit "dist/codex-native/<id>"`；安装已上架的宠物：`npx petdex install <slug>` |
| **任意能读图的客户端/播放器** | `dist/generic-assets/<id>/` | 含接触表与 `previews/*.gif|webp`；**优先用 WebP**（GIF 只有 1 bit 透明、边缘会有硬边） |

> 本仓库的桌面安装步骤使用 `codex-native`；网页版上传使用 `codex-standard-9row`。官方桌面安装入口同时接受 v1 与 v2 版式，本仓库的 v2 素材按 11 行版式制作，所以桌面端按上面步骤装 `codex-native`。

### 名称与目录名对照

| 名称 | 目录名（= `pet.json` 里的 `id`） |
|---|---|
| ChatGPT 白发龙娘 Q 版 | `chatgpt-white-dragon-chibi-v5` |
| Claude 橙书娘 Q 版 | `claude-orange-scholar-chibi-v3` |
| DeepSeek 蓝鲸女仆 Q 版 | `deepseek-whale-maid-chibi-v4` |
| Gemini 星猫娘 Q 版 | `gemini-star-cat-chibi-v1` |
| Grok 暗金哥特娘 Q 版 | `grok-gothic-chibi-v1` |
| Kimi 月影娘 Q 版 | `kimi-moon-maid-chibi-v2` |
| Qwen 蓝发学者娘 Q 版 | `qwen-chibi-scholar-v3` |
| 智谱 珊瑚技术娘 Q 版 | `zhipu-chibi-tech-v2` |

---

## 三、常见问题

- **列表里看不到宠物** ⇒ ① 文件夹名与 `pet.json` 的 `id` 一致？② 两个文件在同一层？③ 重启应用后再刷新。
- **显示成马赛克 / 错位** ⇒ 先核对图集版式与 `pet.json` 配置；如果是版式装错：本仓库的桌面安装步骤用 11 行（1536 × 2288），网页版用 9 行（1536 × 1872）。
- **动画错位** ⇒ 先核对图集版式与 `pet.json` 的配置。
- **边上有硬边 / 绿边** ⇒ GIF 预览可能出现硬边，建议改看 `previews/*.webp`；如果 WebP 或应用里仍然有绿边，请反馈具体角色。
- **想自己改** ⇒ 直接替换 `<id>/` 里那两份文件；改 v2 时记得保留 `"spriteVersionNumber": 2`。

---

## 四、想更深入

| 想了解 | 看这里 |
|---|---|
| 完整图集规格（行序、每格用几列、`pet.json` 字段） | [`dist/SPEC.md`](dist/SPEC.md) |
| 安装脚本做了什么、怎么核对 | [`dist/install-codex.sh`](dist/install-codex.sh)（纯 shell，不联网、不用 sudo；默认装到 `~/.codex/pets/`，并在同级建 `pets_backup-<时间戳>/` 备份目录；设了 `CODEX_HOME` 则两者都跟着变） |
| 质量门（契约 / 预览时长 / 绿边残留） | [`tools/`](tools/) |
| 校验器输出与修正记录 | `*/validation.json`、[`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md)、[`CHANGELOG-greenfix-2026-09-20.md`](CHANGELOG-greenfix-2026-09-20.md) |
| 许可与二次创作 | [`LICENSE`](LICENSE)、[`NOTICE.md`](NOTICE.md) |
