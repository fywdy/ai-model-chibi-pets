#!/usr/bin/env bash
# 把宠物包安装到 Codex：${CODEX_HOME:-$HOME/.codex}/pets/<id>/
#
# 用法: bash install-codex.sh [native|9row] [bundle目录] [--force]
#   native（默认）= v2 母版：11 行 1536×2288，pet.json 含 spriteVersionNumber: 2  ← 装 Codex 用这个
#   9row          = v1 版式： 9 行 1536×1872，pet.json 省略该字段            ← 只给认 v1 的客户端
#   --force       = 允许用不同版式覆盖已安装的同名宠物（默认拒绝，防止 v1/v2 错配）
#
# 行为：只读预检全部通过后才会写用户目录；写入前把已存在的同名宠物整体备份；
#       全程不联网、不用 sudo、不删除任何用户文件。
set -euo pipefail

FORCE=0
VARIANT=""
BUNDLE=""
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    native|9row) [ -z "$VARIANT" ] && VARIANT="$arg" ;;
    *) BUNDLE="$arg" ;;
  esac
done
VARIANT="${VARIANT:-native}"
BUNDLE="${BUNDLE:-$(cd "$(dirname "$0")/.." && pwd)}"

case "$VARIANT" in
  native) SUB="codex-native";      WANT_V=2; LABEL="v2 母版 1536×2288（11 行）" ;;
  9row)   SUB="codex-standard-9row"; WANT_V=1; LABEL="v1 版式 1536×1872（9 行）" ;;
esac

SRC="$BUNDLE/dist/$SUB"
[ -d "$SRC" ] || { echo "找不到 $SRC"; exit 2; }

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PETS="$CODEX_HOME/pets"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$CODEX_HOME/pets_backup-$STAMP"

# 跨平台取 sha256 前 16 位（Linux: sha256sum / macOS: shasum）
hash16() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | cut -c1-16
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | cut -c1-16
  else
    echo "(本机无 sha256 工具)"
  fi
}

echo "变体: ${LABEL}"
echo "来源: $SRC"
echo "目标: $PETS"
echo

# ---------- ① 只读预检（任何一套不合规就整体中止，不动用户目录） ----------
preflight_fail=0
plan=()
for pack in "$SRC"/*/; do
  [ -f "$pack/pet.json" ] || continue
  id="$(basename "$pack")"
  sheet="$pack/spritesheet.webp"

  if [ ! -f "$sheet" ]; then
    echo "  ✗ ${id}: 缺少 spritesheet.webp"; preflight_fail=1; continue
  fi
  magic="$(head -c 12 "$sheet" | od -An -tx1 | tr -d ' \n')"
  case "$magic" in
    52494646????????57454250) ;;
    *) echo "  ✗ ${id}: 不是 WebP（RIFF/WEBP 魔数不符）"; preflight_fail=1; continue ;;
  esac
  bytes="$(wc -c < "$sheet" | tr -d ' ')"
  if [ "$bytes" -lt 100000 ] || [ "$bytes" -gt 20971520 ]; then
    echo "  ✗ ${id}: 图集体积异常（${bytes} 字节，预期 100KB–20MiB）"; preflight_fail=1; continue
  fi
  if ! grep -q "\"id\"[[:space:]]*:[[:space:]]*\"${id}\"" "$pack/pet.json"; then
    echo "  ✗ ${id}: pet.json 里的 id 与目录名不一致"; preflight_fail=1; continue
  fi
  if grep -q '"spriteVersionNumber"' "$pack/pet.json"; then
    src_v=2
  else
    src_v=1
  fi
  if [ "$src_v" != "$WANT_V" ]; then
    echo "  ✗ ${id}: 包内声明为 v${src_v}，与所选变体（v${WANT_V}）不符"; preflight_fail=1; continue
  fi

  # 已安装同名宠物时：版式不同必须显式 --force（防 v1/v2 交错覆盖）
  conflict=""
  if [ -f "$PETS/$id/pet.json" ]; then
    if grep -q '"spriteVersionNumber"' "$PETS/$id/pet.json"; then
      have_v=2
    else
      have_v=1
    fi
    if [ "$have_v" != "$WANT_V" ]; then
      conflict="已安装的是 v${have_v}，本次要装 v${WANT_V}"
      if [ "$FORCE" != "1" ]; then
        echo "  ✗ ${id}: ${conflict} —— 拒绝覆盖（确认要换版式请加 --force）"
        preflight_fail=1; continue
      fi
    fi
  fi
  plan+=("$id|$conflict")
done

if [ "$preflight_fail" != "0" ]; then
  echo
  echo "  预检未通过，未做任何改动 ✗"
  exit 1
fi

# ---------- ② 备份 + 安装 ----------
mkdir -p "$PETS"
installed=0
for entry in "${plan[@]}"; do
  id="${entry%%|*}"
  conflict="${entry#*|}"
  pack="$SRC/$id"
  if [ -d "$PETS/$id" ]; then
    mkdir -p "$BACKUP"
    cp -R "$PETS/$id" "$BACKUP/$id"
  fi
  mkdir -p "$PETS/$id"
  cp "$pack/pet.json" "$PETS/$id/pet.json"
  cp "$pack/spritesheet.webp" "$PETS/$id/spritesheet.webp"
  installed=$((installed + 1))
  [ -n "$conflict" ] && echo "  ✓ $id（强制换版式：${conflict}）" || echo "  ✓ $id"
done

echo
echo "  已安装 $installed 套（变体: ${LABEL}）到 $PETS"
[ -d "$BACKUP" ] && echo "  原文件已备份: $BACKUP"
echo "  校验值（sha256，可与 dist/ 下同名文件比对）:"
for entry in "${plan[@]}"; do
  id="${entry%%|*}"
  printf "    %s  %s\n" "$(hash16 "$PETS/$id/spritesheet.webp")" "$id/spritesheet.webp"
done
echo "  下一步: 重启 Codex 桌面版 → 设置 → Pets → Refresh 后选择宠物"
