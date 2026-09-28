#!/usr/bin/env bash
# 把宠物包安装到 Codex：~/.codex/pets/<id>/
# 用法: bash install-codex.sh [native|9row] [bundle目录]
#   native（默认）= 11 行母版（与现装版本结构一致）
#   9row          = 官方标准 1536x1872
set -euo pipefail

VARIANT="${1:-native}"
BUNDLE="${2:-$(cd "$(dirname "$0")/.." && pwd)}"

case "$VARIANT" in
  native) SUB="codex-native" ;;
  9row)   SUB="codex-standard-9row" ;;
  *) echo "未知变体: ${VARIANT}（可选 native | 9row）"; exit 2 ;;
esac

SRC="$BUNDLE/dist/$SUB"
[ -d "$SRC" ] || { echo "找不到 $SRC"; exit 2; }

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PETS="$CODEX_HOME/pets"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$CODEX_HOME/pets_backup-$STAMP"

mkdir -p "$PETS"
installed=0
for pack in "$SRC"/*/; do
  [ -f "$pack/pet.json" ] || continue
  id="$(basename "$pack")"
  if [ -d "$PETS/$id" ]; then
    mkdir -p "$BACKUP"
    cp -R "$PETS/$id" "$BACKUP/$id"
  fi
  mkdir -p "$PETS/$id"
  cp "$pack/pet.json" "$PETS/$id/pet.json"
  cp "$pack/spritesheet.webp" "$PETS/$id/spritesheet.webp"
  installed=$((installed + 1))
  echo "  ✓ $id"
done

echo
echo "  已安装 $installed 套（变体: ${VARIANT}）到 $PETS"
[ -d "$BACKUP" ] && echo "  原文件已备份: $BACKUP"
echo "  下一步: 重启 Codex 桌面版 → 设置里选择宠物"
