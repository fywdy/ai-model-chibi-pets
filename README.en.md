# Eight Chibi AI-Mascot Pets for the ChatGPT App

Eight chibi pets for the ChatGPT app, based on AI-mascot character designs from the community.
They sit in your window while you chat: running when work is happening, blinking when they wait for you,
slumping when something fails.

- **8 packs**, each with 9 animation states + 16 look directions
- The sprite sheets are AI-generated and checked by hand, frame by frame, cleaning up chroma residue and bad cells
- **Community fan work**, not affiliated with any brand — see [`NOTICE.md`](NOTICE.md)

**Quick install**: [macOS desktop](#macos-desktop-app) ｜ [Windows desktop](#windows-desktop-app) ｜ [ChatGPT web](#chatgpt-web)

> **中文说明**: see [`README.md`](README.md)

---

## 1. The eight characters

The images below are each character's idle animation.

| # | Name | Preview |
|---|---|---|
| 1 | ChatGPT · White Dragon | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="88" alt="idle"> |
| 2 | Claude · Orange Scholar | <img src="claude-orange-scholar-chibi-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 3 | DeepSeek · Whale Maid | <img src="deepseek-whale-maid-chibi-v4/qa/previews/idle.gif" width="88" alt="idle"> |
| 4 | Gemini · Star Cat | <img src="gemini-star-cat-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 5 | Grok · Dark Gothic | <img src="grok-gothic-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 6 | Kimi · Moon Shadow | <img src="kimi-moon-maid-chibi-v2/qa/previews/idle.gif" width="88" alt="idle"> |
| 7 | Qwen · Blue Scholar | <img src="qwen-chibi-scholar-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 8 | Zhipu · Coral Techie | <img src="zhipu-chibi-tech-v2/qa/previews/idle.gif" width="88" alt="idle"> |

Install folder names are listed under [names and folders](#names-and-folders) below.

### Animation previews (a few states, pack ① shown)

| `idle` | `running-right` | `running-left` | `waving` |
|---|---|---|---|
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-right.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-left.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waving.gif" width="96"> |
| **`jumping`** | **`failed`** | **`waiting`** | **`review`** |
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/jumping.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/failed.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waiting.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/review.gif" width="96"> |

Every character folder has the full set of 9 previews (GIF + WebP) in `qa/previews/`.

---

## 2. How to install

**One thing to get right: there are two layouts, and using the wrong one misaligns the frames.**

| Layout | Size | For | Folder |
|---|---|---|---|
| **v2 · 11 rows** | 1536 × 2288 | **ChatGPT desktop app** (macOS / Windows) | `dist/codex-native/<id>/` |
| **v1 · 9 rows** | 1536 × 1872 | **custom pets on ChatGPT web**, v1-only clients | `dist/codex-standard-9row/<id>/` |

### macOS desktop app

Copy the **whole block** and paste it into Terminal:

```bash
V=v1.0.0; SHA=5868c80d48e505f0bb50b5b222d0523c7a169d2cdbb167be1590333a1aa5a9ca
d="${TMPDIR:-/tmp}/pets-install"; mkdir -p "$d" && cd "$d" \
 && curl -fL -C - --retry 3 --retry-all-errors -o pets.tar.gz \
    "https://gh-proxy.com/https://github.com/fywdy/chatgpt-chibi-pets/releases/download/$V/codex-pets-install-$V.tar.gz" \
 && echo "$SHA  pets.tar.gz" | shasum -a 256 -c - \
 && tar xzf pets.tar.gz && bash "codex-pets-install-$V/dist/install-codex.sh" native
```

It verifies the download's SHA-256 first (if the digest doesn't match it stops and does not run the installer),
then unpacks and installs all 8 packs into `~/.codex/pets/`, backing up anything it overwrites.
Afterwards restart the app, then go to **Settings → Pets → Refresh** and pick your pet. Then type `/pet`, or choose **Show pet** from the command menu, and it appears on screen.

> Pinned release tag + `gh-proxy` mirror; the same digest is committed at `dist/SHA256SUMS`, compare it yourself.
> Slow network? Run the same block again — `-C -` resumes. Add `--noproxy '*'` if a local proxy makes the mirror slower.
> Install elsewhere: `export CODEX_HOME="/your/path"` first, then run the command. The default is `~/.codex/pets/`, with a sibling `pets_backup-<timestamp>/` backup — setting `CODEX_HOME` moves both.
> Roll back by copying `~/.codex/pets_backup-<timestamp>/<id>/` back.

### Windows desktop app

1. Repo page → green **Code** → **Download ZIP** → unzip.
2. Copy each `dist\codex-native\<id>\` folder (the whole folder) into `%USERPROFILE%\.codex\pets\` — that is the `pets\` parent folder. Create it if it doesn't exist. When you're done, the files should be at:
   ```
   %USERPROFILE%\.codex\pets\<id>\pet.json
   %USERPROFILE%\.codex\pets\<id>\spritesheet.webp
   ```
   Copy all 8 folders if you want them all.
3. Open the **ChatGPT app → Settings → Pets → Refresh** and pick your pet. Then type `/pet`, or choose **Show pet** from the command menu, and the pet appears on screen.

> The folder name must match the `id` inside `pet.json` **exactly**, and `pet.json` + `spritesheet.webp` must sit **side by side**.
> To remove one: just delete `%USERPROFILE%\.codex\pets\<id>\` (that folder only holds pet assets).

### ChatGPT web

On the web you don't copy folders — you upload one image.

1. Download the repo first: repo page → **Code** → **Download ZIP**, then unzip — you need the file below.
2. Open ChatGPT on the web → **Settings → Personalization → Pet**. (Whether the Pet entry appears depends on your account and workspace; web pets show up in supported ChatGPT Work conversations.)
3. Click **Upload pet** and choose this file (transparent background · exactly 1536 × 1872 · ≤ 20 MiB):
   ```
   dist/codex-standard-9row/<id>/spritesheet.webp
   ```
4. Save and select it.

> The web slot only accepts **1536 × 1872 (the 9-row layout)** — don't upload the 11-row one.
> Pets installed in the desktop app's local `~/.codex/pets/` do **not** sync to the web; install both if you want both.

### Other clients

| Client | Use | How |
|---|---|---|
| **clawd-on-desk** | `dist/import-packages/<id>.zip` (if rejected, try `<id>-foldered.zip`) | Settings → Themes → Import pet zip |
| **CoPet** | same zip | Import pet pack |
| **Petdex** | `dist/codex-standard-9row/<id>/` or `codex-native` | Submit a local pack: `npx petdex submit "dist/codex-native/<id>"`; install one that's already listed: `npx petdex install <slug>` |
| **Any image-capable client / player** | `dist/generic-assets/<id>/` | Contact sheets + `previews/*.gif|webp`; **prefer the WebP** (GIF has 1-bit transparency and hard edges) |

> This repo's desktop steps use `codex-native`; the web upload uses `codex-standard-9row`. The official desktop entry point accepts both v1 and v2 layouts, and this repo's v2 sheets are built in the 11-row layout, so use `codex-native` for the desktop as described above.

### Names and folders

| Name | Folder (= the `id` in `pet.json`) |
|---|---|
| ChatGPT · White Dragon | `chatgpt-white-dragon-chibi-v5` |
| Claude · Orange Scholar | `claude-orange-scholar-chibi-v3` |
| DeepSeek · Whale Maid | `deepseek-whale-maid-chibi-v4` |
| Gemini · Star Cat | `gemini-star-cat-chibi-v1` |
| Grok · Dark Gothic | `grok-gothic-chibi-v1` |
| Kimi · Moon Shadow | `kimi-moon-maid-chibi-v2` |
| Qwen · Blue Scholar | `qwen-chibi-scholar-v3` |
| Zhipu · Coral Techie | `zhipu-chibi-tech-v2` |

---

## 3. Troubleshooting

- **The pet doesn't show up** ⇒ ① does the folder name match the `id` in `pet.json`? ② are both files side by side? ③ restart the app, then Refresh.
- **Garbled / misaligned frames** ⇒ check the atlas layout against your `pet.json` first. If the layout is the problem: this repo's desktop steps use 11 rows (1536 × 2288), the web upload uses 9 rows (1536 × 1872).
- **Animation is offset** ⇒ check the atlas layout against your `pet.json` config.
- **Hard or green edges** ⇒ GIF previews can show hard edges; try `previews/*.webp`. If the WebP or the app still shows green edges, tell us which character.
- **Want to edit one** ⇒ just replace the two files inside `<id>/`; keep `"spriteVersionNumber": 2` for v2.

---

## 4. Going deeper

| If you want | Look at |
|---|---|
| Full atlas spec (row order, frame counts per animation, `pet.json` fields) | [`dist/SPEC.md`](dist/SPEC.md) |
| What the installer does, and how to check it | [`dist/install-codex.sh`](dist/install-codex.sh) (pure shell, no network, no sudo; installs into `~/.codex/pets/` and creates a sibling `pets_backup-<timestamp>/` backup — setting `CODEX_HOME` moves both) |
| Quality gates (contract / preview timing / chroma residue) | [`tools/`](tools/) |
| Validator output & repair history | `*/validation.json`, [`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md), [`CHANGELOG-greenfix-2026-09-20.md`](CHANGELOG-greenfix-2026-09-20.md) |
| Licence & fan-work rules | [`LICENSE`](LICENSE), [`NOTICE.md`](NOTICE.md) |
