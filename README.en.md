# AI Model Chibi Pets · Codex Desktop Pet Sprite Packs (Q-style v5)

> ## 🎨 What this is
> **Community fan-art creations inspired by AI brands.** Eight Q-style anthropomorphic desktop pets —
> one per brand — independently designed by a community author from each brand's public imagery,
> palette and tone, packaged in Codex's pet format.
> All are **unofficial fan works**: not affiliated with, endorsed by, sponsored by, or representing
> OpenAI / Anthropic / Google / xAI / DeepSeek / Moonshot / Alibaba / Zhipu in any way, and not their
> official mascots or positions. Brand words in character names are used **for identification only** —
> see [`NOTICE.md`](NOTICE.md).
>
> ## 🤖 AI-generated artwork
> **All character artwork in this repository was produced by AI image-generation models** and then
> processed by hand: per-frame usability checks, visual review, and green-screen residue removal
> (green-ish pixels → transparent, outline edges included; gate numbers in `chroma-verify.json`).
> The images therefore show the usual generative traits: occasional inconsistent detail, slight
> frame-to-frame jitter, occasional distortion in hands and feet.
> Dialogue lines, names/ids, and the validation/review records were written or judged by a human.
>
> 中文说明: [README.md](README.md) · Pre-publication verification: [`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md)

## 1. Characters (each cell is that pack's real `idle.gif`)

| # | id (= install folder) | Name | Design | Preview |
|---|---|---|---|---|
| 1 | `chatgpt-white-dragon-chibi-v5` | ChatGPT White Dragon | silver-white hair, grey horns, solid white dragon tail | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="88" alt="idle"> |
| 2 | `claude-orange-scholar-chibi-v3` | Claude Orange Scholar | orange-haired bookish girl, cream/orange/black scholar dress | <img src="claude-orange-scholar-chibi-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 3 | `deepseek-whale-maid-chibi-v4` | DeepSeek Blue Whale Maid | blue hair, upward-curving solid whale tail, white apron | <img src="deepseek-whale-maid-chibi-v4/qa/previews/idle.gif" width="88" alt="idle"> |
| 4 | `gemini-star-cat-chibi-v1` | Gemini Star Cat | purple-blue gradient hair, heterochromia, star ornaments | <img src="gemini-star-cat-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 5 | `grok-gothic-chibi-v1` | Grok Dark Gothic | blonde twin-tails, horned crown, bat motifs | <img src="grok-gothic-chibi-v1/qa/previews/idle.gif" width="88" alt="idle"> |
| 6 | `kimi-moon-maid-chibi-v2` | Kimi Moon Maid | silver-white hair, layered black-grey & pale-violet gown | <img src="kimi-moon-maid-chibi-v2/qa/previews/idle.gif" width="88" alt="idle"> |
| 7 | `qwen-chibi-scholar-v3` | Qwen Blue Scholar | indigo Chinese-style dress, folding fan, bead tassel | <img src="qwen-chibi-scholar-v3/qa/previews/idle.gif" width="88" alt="idle"> |
| 8 | `zhipu-chibi-tech-v2` | Zhipu Coral Tech | coral-orange hair, white beret, tartan skirt, tool bag | <img src="zhipu-chibi-tech-v2/qa/previews/idle.gif" width="88" alt="idle"> |

### Animation legend — the 9 standard states (pack ① as the example)

| `idle` | `running-right` | `running-left` | `waving` |
|---|---|---|---|
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/idle.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-right.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running-left.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waving.gif" width="96"> |
| **`jumping`** | **`failed`** | **`waiting`** | **`review`** |
| <img src="chatgpt-white-dragon-chibi-v5/qa/previews/jumping.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/failed.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/waiting.gif" width="96"> | <img src="chatgpt-white-dragon-chibi-v5/qa/previews/review.gif" width="96"> |

> `running` (working): <img src="chatgpt-white-dragon-chibi-v5/qa/previews/running.gif" width="88" alt="running">
> Every pack ships these 9 GIFs (plus lossless WebP versions with full alpha — prefer those) under
> its own `<id>/qa/previews/`.

## 2. What exactly is the "Codex v2 pet sprite spec"?

**In one line:** it is the sprite-atlas contract that Codex's **custom pets** are required to satisfy.
It is **not published as a web document** ✗ — it ships inside Codex itself, in the `hatch-pet` skill
(delivered via the OpenAI-curated `work-pets` plugin):

```text
${CODEX_HOME:-$HOME/.codex}/skills/hatch-pet/references/codex-pet-contract.md   # titled: Codex V2 Pet Contract
${CODEX_HOME:-$HOME/.codex}/skills/hatch-pet/references/animation-rows.md       # per-row states, used columns, durations
```

> This repository follows that contract; **if anything here disagrees with the file on your machine,
> that file wins** ✓.

### v2 vs v1 (get this wrong and frames mis-parse)

| Item | **v2** (this repo's main artifact) | **v1** |
|---|---|---|
| `spriteVersionNumber` | **`2`** | **omit the field** (defaults to v1) |
| Atlas dimensions | **1536 × 2288** | **1536 × 1872** |
| Rows | **11** (9 standard states + 2 look rows) | 9 |
| Cell / columns | 192 × 208 / **8 columns** | same |
| Background | transparent; **unused cells must be fully transparent** | same |

⚠️ Two hard rules in the contract:

1. The 8×9 1536×1872 atlas **is an intermediate assembly artifact only — "never package it as a newly hatched pet."**
2. **Omitting `spriteVersionNumber` falls back to v1**, and then a 2288-tall atlas is rejected; conversely,
   **declaring v2 while shipping an 1872-tall atlas mis-parses**.

⇒ That is why `dist/codex-standard-9row/` ships as the **v1 layout** for clients that only understand v1:
its `pet.json` **omits** `spriteVersionNumber` ✓. Do not feed those two files into Codex's v2 flow ✗.

### Row order (0-based)

| Row | State | Used columns | Notes |
|---|---|---|---|
| 0 | `idle` | 0–5 | calm loop; also the reduced-motion first frame |
| 1 | `running-right` | 0–7 | locomotion to the right |
| 2 | `running-left` | 0–7 | mirror only if identity/prop handedness stays correct |
| 3 | `waving` | 0–3 | greeting / attention gesture |
| 4 | `jumping` | 0–4 | anticipation → lift → peak → descent → settle |
| 5 | `failed` | 0–7 | readable error / deflated reaction |
| 6 | `waiting` | 0–5 | expectant asking pose for approval or input |
| 7 | `running` | 0–5 | active work (not literal foot-running) |
| 8 | `review` | 0–5 | focused inspection of output |
| 9 | look directions A | 0–7 | `000°`→`157.5°`, 22.5° per frame |
| 10 | look directions B | 0–7 | `180°`→`337.5°`, 22.5° per frame |

- **`000°` is straight up / 12 o'clock — not front** ✓; front is the no-vector deadzone and falls back to `idle` ✓.
- Per-row frame durations and the "unused cells must be fully transparent" detail live in `animation-rows.md` above ✓.
- All eight packs here are **8×11 masters** ✓ with the full 16 look directions ✓.

### `pet.json` (v2)

```json
{
  "id": "chatgpt-white-dragon-chibi-v5",
  "displayName": "ChatGPT White Dragon",
  "description": "One short sentence (every pack here carries an 'unofficial fan pet' note).",
  "spriteVersionNumber": 2,
  "spritesheetPath": "spritesheet.webp"
}
```

- `id`: lowercase hyphenated slug, **must equal the install folder name** ✓
- `spritesheetPath`: relative path inside the pack (same level as `pet.json`) ✓
- Install location: `${CODEX_HOME:-$HOME/.codex}/pets/<id>/{pet.json,spritesheet.webp}` ✓

## 3. This repository's atlas spec

| Item | Value |
|---|---|
| Cell | **192 × 208** px |
| Columns × rows | **8 × 11** = 1536 × 2288 (v2 master, main artifact) |
| Other layout | **8 × 9** = 1536 × 1872 (**v1**, for v1-only clients — see §2) |
| Format | WebP, **transparent**, `lossless=True, exact=True` (pixel-lossless) |
| Size | 1.68 – 3.04 MiB per pack (self-imposed 20 MiB limit, 85%+ headroom) |

## 4. Installation guide (English)

### ① Codex desktop / CLI — recommended

```bash
# run from the root of this repository
bash dist/install-codex.sh native     # 11-row v2 master (1536×2288) — use this for Codex
```

The script copies each pack's `pet.json` + `spritesheet.webp` into `~/.codex/pets/<id>/`,
**backs up any existing pet with the same id** into `~/.codex/pets_backup-<timestamp>/` first,
and prints one `✓ <id>` line per pack.

Then open **Codex desktop → Settings → Pets → Refresh**; the eight pets appear in your custom pet list ✓.

- Custom location: `CODEX_HOME=/your/path bash dist/install-codex.sh native`
- Single pack only: copy `dist/codex-native/<id>/{pet.json,spritesheet.webp}` to `~/.codex/pets/<id>/`
- **Uninstall / roll back**: delete `~/.codex/pets/<id>/`; to restore a backup, copy
  `~/.codex/pets_backup-<timestamp>/<id>/` back into `~/.codex/pets/`

### ② Clients that only understand v1 (1536×1872)

Use the two files inside `dist/codex-standard-9row/<id>/` ✓ (its `pet.json` **omits** `spriteVersionNumber`,
i.e. v1 ✓). Do **not** feed the 11-row v2 master to those clients ✗, and do not install the 9-row variant
into Codex ✗ (see the two hard rules in §2).

### ③ Third-party desktop pet clients

Importers disagree about the zip's internal layout, so **both variants ship** (containing the **v2 / 11-row** pack ✓):

| Client | Which file | How |
|---|---|---|
| **clawd-on-desk** | `dist/import-packages/<id>.zip` (fallback: `<id>-foldered.zip`) | Settings → Themes → Import pet zip |
| **CoPet** | same zips | Import pet pack |
| **Petdex** | `dist/codex-standard-9row/<id>/` or native | format matches; submit to the gallery or `npx petdex install` |

Try the flat zip first; if the importer can't find `pet.json`, retry with the **foldered** variant ✓.

### ④ Any image-capable client / player

Use `dist/generic-assets/<id>/`: a contact sheet plus `previews/` (one GIF and one WebP per state) ✓.

> **Prefer the `.webp` previews**: GIF has only 1-bit transparency and shows hard edges; the WebP
> versions are lossless with full alpha ✓.

### ⑤ Troubleshooting

- **Pet not listed** → check the folder name equals `pet.json`'s `id` **exactly**, and that
  `spritesheet.webp` sits **next to** `pet.json`, then restart Codex / hit Refresh ✓.
- **Dimension or frame mis-parse errors** → almost always a **v1 layout paired with a v2 declaration**
  (or vice versa) ✗ — match the correct pair from §2 ✓.
- **Green fringe around the character** → this pack set passes the hard green-screen gate (0 residue) ✓;
  a fringe you see is almost always the client compositing transparency over a **black** background —
  use an alpha-aware client, or view the `previews/*.webp` ✓.
- **Want to edit** → replace the two files in `dist/codex-native/<id>/` ✓; for v2 **keep
  `spriteVersionNumber: 2`** ✓.

### ⑥ Script behaviour & security notes (verifiable yourself)

`dist/install-codex.sh` is a **purely local script: no network, no sudo, deletes nothing** ✓. It only does
"read-only preflight → backup → copy":

1. **Read-only preflight** (if any pack fails, it **aborts entirely without touching anything** ✗): per pack it checks
   that `spritesheet.webp` exists and is WebP (RIFF/WEBP magic ✓), that its size is within 100 KB–20 MiB ✓,
   that `pet.json`'s `id` matches the folder name ✓, that the pack's declared version matches the chosen
   variant ✓, and that **replacing an installed pet of a different layout is refused by default** ✗
   (prevents accidental v1/v2 mixing; pass `--force` if you really mean it ✓).
2. **Backup**: only directories that will actually be overwritten are backed up wholesale to
   `${CODEX_HOME}/pets_backup-<timestamp>/` ✓.
3. **Copy**: writes only `${CODEX_HOME:-$HOME/.codex}/pets/<id>/{pet.json,spritesheet.webp}` ✓ and prints the
   first 16 hex chars of each sha256 so you can diff them against `dist/` ✓.

**Dry-run it first** (installs into a throwaway dir — your real Codex home is untouched ✓):

```bash
CODEX_HOME=/tmp/cx_test bash dist/install-codex.sh native
```

## 5. Quality gates (per pack)

| Gate | Threshold | Measured |
|---|---|---|
| Opaque green-ish pixels | ≤ 200 | **0** (8/8) |
| Largest green blob | ≤ 20 px | **0** (8/8) |
| Anti-aliased fringe green | ≤ 60 px | **0** (8/8) |
| **Solid non-green pixels cleared** | **= 0** | **0** (8/8) |
| **Non-green pixels recoloured** | **= 0** | **0** (8/8) |

The repair therefore touched **only green-ish pixels** — body, outline and palette are unchanged ✓.
Per-pack numbers: `greenfix-report.json`, `chroma-verify.json`,
[`CHANGELOG-greenfix-2026-09-20.md`](CHANGELOG-greenfix-2026-09-20.md). Pre-publication leak scan and
spec verification: [`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md) ✓.

## 6. Repository layout

```
<id>/                         # master assets + records
  pet.json                    # v2 manifest (spriteVersionNumber: 2)
  spritesheet.webp            # 8×11 = 1536×2288, transparent
  dialogue.zh-CN.json  validation.json  visual-review.json  contact-sheet.png  README.md
  qa/previews/*.gif|*.webp    # 9 state previews (the README legend uses these)
dist/
  codex-native/<id>/          # v2: pet.json + 11-row 1536×2288 (install into Codex)
  codex-standard-9row/<id>/   # v1: pet.json (no spriteVersionNumber) + 9-row 1536×1872
  generic-assets/<id>/        # contact sheet + previews
  import-packages/<id>.zip            # v2, flat layout
  import-packages/<id>-foldered.zip   # v2, foldered layout
  install-codex.sh  SPEC.md  dist-report.json  import-packages-report.json
CHANGELOG-greenfix-2026-09-20.md   chroma-verify.json   greenfix-report.json
docs/README-bundle-original.md
NOTICE.md   LICENSE   LICENSE-MIT   RELEASE-REPORT-2026-09-27.md
```

## 7. Licence & reuse

| Part | Licence |
|---|---|
| Character sheets, contact sheets, previews (**AI-generated + human-repaired** art) | **CC BY-NC 4.0** (attribution, **non-commercial**) — see [`LICENSE`](LICENSE) |
| `install-codex.sh`, scripts and JSON tool output | **MIT** — see [`LICENSE-MIT`](LICENSE-MIT) |

Remix, recolour, or build your own pet pack — as long as you **keep [`NOTICE.md`](NOTICE.md)** and stay
**non-commercial** ✓. Brand words in character names are for identification only; trademarks belong to
their owners ✓. If a rights holder objects, open an Issue and we will take the relevant character (or the
whole repository) down ✓.

## 8. Sources & credits

- **Codex v2 pet format**: governed by `codex-pet-contract.md` (*Codex V2 Pet Contract*) and
  `animation-rows.md` inside the `hatch-pet` skill that ships with Codex ✓ (delivered via the
  OpenAI-curated `work-pets` plugin). This repository produces and self-checks against it ✓.
- The eight characters are **community fan-art creations** ✓, made by this repository's author with an
  AI image-generation + human per-frame review/repair pipeline ✓.
- Client support (Codex / ChatGPT web / Petdex / clawd-on-desk / CoPet) was tested and researched on
  2026-09-20 ✓; the full matrix and "why not client X" live in [`dist/SPEC.md`](dist/SPEC.md) ✓.
