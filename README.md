# 8 套 AI 模型娘 Q 版桌宠（适配 ChatGPT 应用）

把 8 家 AI 品牌的形象各画成一个 Q 版小人，做成 **ChatGPT 应用能直接用的桌宠**。
它们会在你聊天时待在窗口里：干活时跑动、等你输入时眨眼、出错时蔫掉。

- **8 套**，每套 9 个状态 + 16 个注视方向的动画（共 24 张图集，两种尺寸版式）
- 美术由 AI 图像模型生成，之后由人工逐格检查、修掉绿幕残留与不合格的格子
- **社区同人创作**：与各品牌方无关联、未获授权或背书，角色名里的品牌词仅用于识别 —— 详见 [`NOTICE.md`](NOTICE.md)

> **English**: see [`README.en.md`](README.en.md)

---

## 一、8 套角色

下图为各套真实的 `idle.gif`（点击文件名可看大图）：

| # | 名称 | 安装目录名（= `pet.json` 里的 `id`） | 预览 |
|---|---|---|---|
| 1 | ChatGPT 白发龙娘 Q 版 | `chatgpt-white-dragon-chibi-v5` | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="88" alt="idle"> |
| 2 | Claude 橙书娘 Q 版 | `claude-orange-scholar-chibi-v3` | <img src="claude-orange-scholar-chibi-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 3 | DeepSeek 蓝鲸女仆 Q 版 | `deepseek-whale-maid-chibi-v4` | <img src="deepseek-whale-maid-chibi-v4/qa/previews/idle.gif" width="88" alt="idle"> |
| 4 | Gemini 星猫娘 Q 版 | `gemini-star-cat-chibi-v1` | <img src="gemini-star-cat-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 5 | Grok 暗金哥特娘 Q 版 | `grok-gothic-chibi-v1` | <img src="grok-gothic-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 6 | Kimi 月影娘 Q 版 | `kimi-moon-maid-chibi-v2` | <img src="kimi-moon-maid-chibi-v2/qa/previews/idle.gif" width="88" alt="idle"> |
| 7 | Qwen 蓝发学者娘 Q 版 | `qwen-chibi-scholar-v3` | <img src="qwen-chibi-scholar-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 8 | 智谱 珊瑚技术娘 Q 版 | `zhipu-chibi-tech-v2` | <img src="zhipu-chibi-tech-v2/qa/previews/idle.gif" width="88" alt="idle"> |

### 它们会做的 9 个状态（以 ① 白发龙娘为例）

| `idle` 待机 | `running-right` 右移 | `running-left` 左移 | `waving` 挥手 |
|---|---|---|---|
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-right.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-left.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waving.gif" width="96"> |
| **`jumping` 跳跃** | **`failed` 失败** | **`waiting` 等待你** | **`review` 审查** |
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/jumping.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/failed.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waiting.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/review.gif" width="96"> |

每个角色目录的 `qa/previews/` 里都有全套 9 个状态的 GIF/WebP 可以单独看 ✓

---

## 二、怎么装

⚠️ **先记住一件事：两种版式，装错会错位** ✗

| 版式 | 尺寸 | 给谁用 | 在哪个目录 |
|---|---|---|---|
| **v2 · 11 行** | 1536 × 2288 | **ChatGPT 桌面应用**（macOS / Windows） | `dist/codex-native/<id>/` |
| **v1 · 9 行** | 1536 × 1872 | **ChatGPT 网页版宠物位**、只认 v1 的客户端 | `dist/codex-standard-9row/<id>/` |

### ⓪ macOS · 桌面应用：一行命令（复制粘贴到「终端」）

```bash
V=v1.0.0; SHA=5868c80d48e505f0bb50b5b222d0523c7a169d2cdbb167be1590333a1aa5a9ca
d="${TMPDIR:-/tmp}/pets-install"; mkdir -p "$d" && cd "$d" \
 && curl -fL -C - --retry 3 --retry-all-errors -o pets.tar.gz \
    "https://gh-proxy.com/https://github.com/fywdy/chatgpt-chibi-pets/releases/download/$V/codex-pets-install-$V.tar.gz" \
 && echo "$SHA  pets.tar.gz" | shasum -a 256 -c - \
 && tar xzf pets.tar.gz && bash "codex-pets-install-$V/dist/install-codex.sh" native
```

它会：**先校验下载包的 SHA-256**（不符就停 ✗ 不会执行任何脚本 ✓）→ 解包 → 把 8 套装进 `~/.codex/pets/`，
**覆盖前自动备份** ✓ 最后按提示重启应用 → **设置 → Pets → Refresh** ✓

> 用的是固定版本 tag + `gh-proxy` 镜像 ✓ 校验和也写在仓库 `dist/SHA256SUMS` ✓ 可自行比对 ✓
> 网络慢时**再执行同一行**即可续传（`-C -`）✓；镜像慢可给 curl 加 `--noproxy '*'` 绕开系统代理 ✓
> 装到别处：`CODEX_HOME=/你的路径` ✓ 想回滚：把 `~/.codex/pets_backup-<时间戳>/<id>/` 拷回去 ✓

### ① Windows · 桌面应用：手动复制（不需要命令行）

1. 仓库页 → 绿色 **Code** → **Download ZIP** → 解压
2. 把 `dist\codex-native\<某个 id>\` **整个文件夹**复制到：
   ```
   %USERPROFILE%\.codex\pets\<同一个 id>\
   ```
   没有 `pets` 文件夹就自己建一个 ✓ 8 套都要就复制 8 个文件夹 ✓
3. 打开 **ChatGPT 应用 → 设置（Settings）→ Pets → Refresh** → 选中即可 ✓

> 文件夹名必须与 `pet.json` 里的 `id` **完全一致** ✓ 且 `pet.json` 与 `spritesheet.webp` **必须在同一层** ✓
> 想删掉某套：直接删 `%USERPROFILE%\.codex\pets\<id>\` 文件夹 ✓（这里只放宠物素材 ✓）

### ② ChatGPT 网页版宠物位：**不是复制文件夹** ✗（上传一张图）

1. 打开 ChatGPT 网页版 → **Settings → Personalization → Pet**
2. 点 **Upload pet** ✓ 选这张图（透明背景 · 正好 1536 × 1872 · ≤ 20 MiB）：
   ```
   dist/codex-standard-9row/<id>/spritesheet.webp
   ```
3. 保存后即可选用 ✓

> 网页版只认 **1536 × 1872（9 行版）** ✓ 别传 11 行的那份 ✗
> 桌面端装在本地 `~/.codex/pets/` 的宠物**不会**自动同步到网页版 ✓ 两边要各自装一次 ✓

### ③ 其他客户端

| 客户端 | 用哪份 | 怎么用 |
|---|---|---|
| **clawd-on-desk** | `dist/import-packages/<id>.zip`（被拒就试 `<id>-foldered.zip`） | 设置 → 主题 → 导入宠物 zip |
| **CoPet** | 同上 | 导入宠物包 |
| **Petdex** | `dist/codex-standard-9row/<id>/` 或 `codex-native` | 可直接投稿，或 `npx petdex install` |
| **任意能读图的客户端/播放器** | `dist/generic-assets/<id>/` | 含接触表与 `previews/*.gif|webp`；**优先用 WebP** ✓（GIF 只有 1 bit 透明、边缘会有硬边 ✗） |

> 装到 ChatGPT 应用请务必用 `codex-native`（v2 ✓）；`codex-standard-9row` 是给网页版与 v1 客户端用的 ✓ 别混 ✗

---

## 三、常见问题

- **列表里看不到宠物** ⇒ ① 文件夹名 = `pet.json` 的 `id`？② 两个文件同层？③ 刷新前重启一下应用 ✓
- **显示成马赛克 / 错位** ⇒ 版式用错了 ✓ 桌面用 v2（11 行 1536×2288）✓ 网页用 v1（9 行 1536×1872）✓
- **边上有硬边/绿边** ⇒ 用 GIF 预览才会 ✓ 换成 `previews/*.webp` ✓
- **想自己改** ⇒ 直接替换 `<id>/` 里那两份文件 ✓ 改 v2 时记得保留 `"spriteVersionNumber": 2` ✓

---

## 四、想更深入

| 想了解 | 看这里 |
|---|---|
| 完整图集规格（行序、每格用几列、`pet.json` 字段） | [`dist/SPEC.md`](dist/SPEC.md) |
| 安装脚本做了什么、怎么核对 | [`dist/install-codex.sh`](dist/install-codex.sh)（纯 shell ✓ 不联网 ✗ 不用 sudo ✗ 只写 `~/.codex/` ✓） |
| 质量门（契约 / 预览时长 / 绿边残留） | [`tools/`](tools/) |
| 校验器输出与修正记录 | `*/validation.json`、[`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md)、[`CHANGELOG-greenfix-2026-09-20.md`](CHANGELOG-greenfix-2026-09-20.md) |
| 许可与二次创作 | [`LICENSE`](LICENSE)、[`NOTICE.md`](NOTICE.md) |

**一句话** ✓：8 套社区同人 Q 版桌宠 ✓ AI 生成 + 人工逐格校验 ✓ 两种版式覆盖桌面与网页 ✓ 每条都附可自行核对的校验结果 ✓
