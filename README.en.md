# AI Model Chibi Pets · Codex Desktop Pet Sprite Packs (Q-style v5)

> ## 🤖 AI-generated artwork
> **All character artwork in this repository was produced by AI image-generation models**, then
> processed by hand: per-frame usability checks, visual review, and green-screen residue removal
> (green-ish pixels → transparent, outline edges included; gate numbers in `chroma-verify.json`).
> The images therefore show the usual generative traits: occasional inconsistent detail, slight
> frame-to-frame jitter, occasional distortion in hands and feet.
> Dialogue lines, names/ids, and the validation/review records were written or judged by a human.
>
> ⚠️ **Unofficial fan art.** Not affiliated with, endorsed by, or authorised by OpenAI / Anthropic /
> Google / xAI / DeepSeek / Moonshot / Alibaba / Zhipu. Brand words in character names are used for
> identification only — see [`NOTICE.md`](NOTICE.md).
>
> 中文说明：[README.md](README.md) · Pre-publication verification: [RELEASE-REPORT-2026-09-27.md](RELEASE-REPORT-2026-09-27.md)

Eight Q-style desktop pets in the **Codex v2 pet sprite format** (`pet.json` + `spritesheet.webp`).
Each pack ships **9 official state rows + 2 extra rows of 16-direction gaze**, Chinese personality
dialogue, per-frame validation and a visual review record.

## 1. Characters

| # | id (= install folder name) | Name | Design |
|---|---|---|---|
| 1 | `chatgpt-white-dragon-chibi-v5` | ChatGPT White Dragon | silver-white long hair, grey horns, solid white dragon tail |
| 2 | `claude-orange-scholar-chibi-v3` | Claude Orange Scholar | orange-haired bookish girl, cream/orange/black scholar dress |
| 3 | `deepseek-whale-maid-chibi-v4` | DeepSeek Blue Whale Maid | blue hair, upward-curving solid whale tail, white apron |
| 4 | `gemini-star-cat-chibi-v1` | Gemini Star Cat | purple-blue gradient hair, heterochromia, four-point star ornaments |
| 5 | `grok-gothic-chibi-v1` | Grok Dark Gothic | blonde twin-tails, horned crown, bat motifs |
| 6 | `kimi-moon-maid-chibi-v2` | Kimi Moon Maid | silver-white hair, layered black-grey & pale-violet gown |
| 7 | `qwen-chibi-scholar-v3` | Qwen Blue Scholar | indigo Chinese-style long dress, folding fan, bead tassel |
| 8 | `zhipu-chibi-tech-v2` | Zhipu Coral Tech | coral-orange hair, white beret, tartan skirt, tool bag |

## 2. Sprite sheet spec

| Item | Value |
|---|---|
| Cell | **192 × 208** px |
| Columns × rows | **8 × 11** master (1536 × 2288) / **8 × 9** official standard (1536 × 1872) |
| Format | WebP, **transparent**, `lossless=True, exact=True` (pixel-lossless) |
| Size | 1.68 – 3.04 MiB per pack (Codex limit 20 MiB, 85%+ headroom) |
| Row order | 0 `idle` · 1 `running-right` · 2 `running-left` · 3 `waving` · 4 `jumping` · 5 `failed` · 6 `waiting` · 7 `running` · 8 `review` · 9–10 **extra gaze directions** (45° per frame, 16 total) |

> Rows 9–10 are this pack set's own extension, **outside the official standard**; clients that only
> read the first 9 rows are unaffected.

## 3. Installation guide (English)

### ① Codex desktop / CLI — recommended

```bash
# run from the root of this repository
bash dist/install-codex.sh native     # 11-row master (1536×2288)
# or
bash dist/install-codex.sh 9row       # official 9-row export (1536×1872)
```

The script copies each pack's `pet.json` + `spritesheet.webp` into `~/.codex/pets/<id>/`,
**backs up any existing pet with the same id** into `~/.codex/pets_backup-<timestamp>/` first,
and prints one `✓ <id>` line per pack.

Then open **Codex desktop → Settings → Pets → Refresh**; the eight pets appear in your custom pet
list — pick one and you're done.

- Custom location: `CODEX_HOME=/your/path bash dist/install-codex.sh native`
- Single pack only: copy `dist/codex-native/<id>/{pet.json,spritesheet.webp}` to `~/.codex/pets/<id>/`
- **Uninstall / roll back**: delete `~/.codex/pets/<id>/`. To restore a backed-up version, copy
  `~/.codex/pets_backup-<timestamp>/<id>/` back into `~/.codex/pets/`

### ② ChatGPT web pets

The web version **only accepts 1536×1872 (8×9)** — use the two files inside
`dist/codex-standard-9row/<id>/`. Do **not** feed it the 11-row master (the extra rows fail its
dimension check).

### ③ Third-party desktop pet clients

Importers disagree about the folder layout inside the zip, so **both variants are shipped**:

| Client | Which file | How |
|---|---|---|
| **clawd-on-desk** | `dist/import-packages/<id>.zip` (fallback: `<id>-foldered.zip`) | Settings → Themes → Import pet zip |
| **CoPet** | same zips | Import pet pack |
| **Petdex** | `dist/codex-standard-9row/<id>/` or native | format matches; submit to the gallery or `npx petdex install` |

Try the flat zip first. If the importer complains it cannot find `pet.json`, retry with the
**foldered** variant.

### ④ Any image-capable client / player

Use `dist/generic-assets/<id>/`: a contact sheet (`contact-sheet.png`) plus `previews/`
(one GIF and one WebP per state, 9 states).

> **Prefer the `.webp` previews**: GIF has only 1-bit transparency and tends to show hard edges;
> the WebP versions are lossless with full alpha.

### ⑤ Troubleshooting

- **Pet not listed** → make sure the folder name equals the `id` in `pet.json` **exactly**, and that
  `spritesheet.webp` sits **next to** `pet.json`, then restart Codex / hit Refresh again.
- **Dimension error** → you are probably feeding an 11-row master to a client that only accepts the
  official 9 rows; switch to `codex-standard-9row/`.
- **Green fringe around the character** → this pack set passes the hard green-screen gate
  (0 residue). A fringe you see is almost always the client compositing transparency over a
  **black** background — use an alpha-aware client, or the `previews/*.webp`.
- **Want to edit** → just replace the two files from `dist/codex-native/<id>/`; keep
  `spriteVersionNumber` at `2` in `pet.json`.

## 4. Quality gates (per pack)

| Gate | Threshold | Measured |
|---|---|---|
| Opaque green-ish pixels | ≤ 200 | **0** (8/8) |
| Largest green blob | ≤ 20 px | **0** (8/8) |
| Anti-aliased fringe green | ≤ 60 px | **0** (8/8) |
| **Solid non-green pixels cleared** | **= 0** | **0** (8/8) |
| **Non-green pixels recoloured** | **= 0** | **0** (8/8) |

The repair therefore touched **only green-ish pixels** — character body, outline and palette are
unchanged. Per-pack before/after numbers: `greenfix-report.json`, `chroma-verify.json`,
[`CHANGELOG-greenfix-2026-09-20.md`](CHANGELOG-greenfix-2026-09-20.md). Pre-publication leak scan and
spec verification: [`RELEASE-REPORT-2026-09-27.md`](RELEASE-REPORT-2026-09-27.md).

## 5. Repository layout

```
<id>/                         # master assets + records
  pet.json  spritesheet.webp  dialogue.zh-CN.json
  validation.json  visual-review.json  contact-sheet.png  README.md
  qa/previews/*.gif|*.webp    # 9 state previews
dist/
  codex-native/<id>/          # pet.json + 11-row sheet (Codex native)
  codex-standard-9row/<id>/   # pet.json + 9-row 1536×1872
  generic-assets/<id>/        # contact sheet + previews
  import-packages/<id>.zip    # flat layout
  import-packages/<id>-foldered.zip
  install-codex.sh  SPEC.md  dist-report.json  import-packages-report.json
CHANGELOG-greenfix-2026-09-20.md   chroma-verify.json   greenfix-report.json
docs/README-bundle-original.md
NOTICE.md   LICENSE   LICENSE-MIT   RELEASE-REPORT-2026-09-27.md
```

## 6. Licence & reuse

| Part | Licence |
|---|---|
| Character sheets, contact sheets, previews (**AI-generated + human-repaired** art) | **CC BY-NC 4.0** (attribution, **non-commercial**) — see [`LICENSE`](LICENSE) |
| `install-codex.sh`, scripts and JSON tool output | **MIT** — see [`LICENSE-MIT`](LICENSE-MIT) |

Remix, recolour, or build your own pet pack — as long as you **keep [`NOTICE.md`](NOTICE.md)** and
stay **non-commercial**. Brand words in character names are for identification only; trademarks
belong to their owners. If a rights holder objects, open an Issue and we will take the relevant
character (or the whole repository) down.
