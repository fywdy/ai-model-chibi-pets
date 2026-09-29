#!/usr/bin/env bash
# 把宠物包安装到 Codex：${CODEX_HOME:-$HOME/.codex}/pets/<id>/
#
# 用法: bash install-codex.sh [native|9row] [bundle目录] [--force] [-h|--help]
#   native（默认）= v2 母版：11 行 1536×2288，pet.json 含 spriteVersionNumber: 2  ← 装 ChatGPT 应用用这个
#   9row          = v1 版式： 9 行 1536×1872，pet.json 省略该字段            ← 只给认 v1 的客户端
#   --force       = 允许用不同版式覆盖已安装的同名宠物（默认拒绝，防 v1/v2 错配）
#
# 零依赖：只用系统自带工具。macOS 用自带 bash 3.2 + plutil + od/head/wc/tr/cp/mkdir/shasum；
#         Linux 用 bash 4+ 与 GNU 工具（有 plutil 时同样可用）。不需要装 Python、不需要联网下载。
#
# 行为边界（与 README「脚本行为与安全说明」逐条对应）：
#   · 不联网、不用 sudo、不调用任何删除命令
#   · 只读预检全部通过后才写用户目录；失败即停止并报告已完成/未完成范围
#   · 写入前拒绝符号链接与特殊文件（避免 cp 跟随链接写到目标之外）
#   · 备份到唯一目录；同名备份目录已存在则拒绝复用
#   · 覆盖是「就地更新」：先完成备份再逐份复制（非原子事务，失败时明确报告状态）
#
# 兼容：bash 3.2（macOS 自带）与 bash 4/5、BSD 与 GNU 工具。
# 注意：所有变量插值一律使用 ${var} 花括号形式（中文/全角字符紧邻变量时必须如此，
#       否则 bash 3.2 会把多字节字符并入变量名，报 unbound variable）。
set -euo pipefail

usage() {
  cat <<'USAGE'
用法: bash install-codex.sh [native|9row] [bundle目录] [--force]

  native   安装 v2 母版（11 行 1536×2288，spriteVersionNumber: 2）—— 装进 ChatGPT 应用用这个（默认）
  9row     安装 v1 版式（8×9 1536×1872，pet.json 不带 spriteVersionNumber）—— 只给认 v1 的客户端
  --force  允许用不同版式覆盖已安装的同名宠物（默认拒绝，防止 v1/v2 错配）
  -h,--help 显示本帮助

环境变量: CODEX_HOME（默认 $HOME/.codex）
USAGE
}

# ---------- ① 参数解析（拒绝未知选项、重复变体、多余目录参数） ----------
FORCE=0
VARIANT=""
BUNDLE=""
SEEN_DASHDASH=0
while [ $# -gt 0 ]; do
  arg="$1"; shift
  if [ "${SEEN_DASHDASH}" = "1" ]; then
    if [ -n "${BUNDLE}" ]; then echo "错误: 只能给一个 bundle 目录" >&2; usage >&2; exit 2; fi
    BUNDLE="${arg}"; continue
  fi
  case "${arg}" in
    -h|--help) usage; exit 0 ;;
    --force)   FORCE=1 ;;
    --)        SEEN_DASHDASH=1 ;;
    native|9row)
      if [ -n "${VARIANT}" ]; then echo "错误: 变体只能指定一次（已给 ${VARIANT}）" >&2; usage >&2; exit 2; fi
      VARIANT="${arg}" ;;
    -*) echo "错误: 未知选项 ${arg}" >&2; usage >&2; exit 2 ;;
    *)
      if [ -n "${BUNDLE}" ]; then echo "错误: 只能给一个 bundle 目录" >&2; usage >&2; exit 2; fi
      BUNDLE="${arg}" ;;
  esac
done
VARIANT="${VARIANT:-native}"
BUNDLE="${BUNDLE:-$(cd "$(dirname "$0")/.." && pwd)}"

case "${VARIANT}" in
  native) SUB="codex-native";        WANT_V=2; LABEL="v2 母版 1536×2288（11 行）" ;;
  9row)   SUB="codex-standard-9row"; WANT_V=1; LABEL="v1 版式 1536×1872（9 行）" ;;
esac

SRC="${BUNDLE}/dist/${SUB}"
[ -d "${SRC}" ] || { echo "找不到 ${SRC}" >&2; exit 2; }

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
PETS="${CODEX_HOME}/pets"

# ---------- 工具探测（全部为系统自带，缺失只降级不报错） ----------
have() { command -v "$1" >/dev/null 2>&1; }
USE_PLUTIL=0
if have plutil && [ "$(uname -s)" = "Darwin" ]; then USE_PLUTIL=1; fi
PY=""
if have python3; then
  # macOS 上未装 Command Line Tools 时 /usr/bin/python3 只是个占位程序，运行会弹安装提示
  if python3 -c 'pass' >/dev/null 2>&1; then PY="$(command -v python3)"; fi
fi

# ---------- 纯 bash 读取 WebP 尺寸（不需要 python） ----------
# 输出 "WxH"；失败输出空并返回 1。支持 VP8L（本项目用的无损）、VP8X、VP8（有损）。
# 字节编号为 od 的 1 起序号：1-4 'RIFF' / 9-12 'WEBP' / 13-16 fourcc / 17-20 chunk 长度 / 21 起负载。
# 注意：bash 3.2 不支持 $13 这类两位数位置参数（会解析成 $1 后接 "3"），必须写 ${13}。
webp_size() {
  f="$1"
  b="$(dd if="${f}" bs=1 count=32 2>/dev/null | od -An -tu1 | tr -s ' \n' ' ')"
  # shellcheck disable=SC2086
  set -- ${b}
  [ $# -ge 31 ] || return 1
  # 'RIFF' = 82 73 70 70 ；'WEBP' = 87 69 66 80
  [ "$1$2$3$4" = "82737070" ] || return 1
  [ "$9${10}${11}${12}" = "87696680" ] || return 1
  fcc="${13}${14}${15}${16}"
  if [ "${fcc}" = "86805676" ]; then          # 'VP8L'：21 字节处为 0x2F(47) 签名，22-25 为 32 位小端位域
    [ "${21}" = "47" ] || return 1
    bits=$(( ${22} | (${23} << 8) | (${24} << 16) | (${25} << 24) ))
    echo "$(( (bits & 16383) + 1 ))x$(( ((bits >> 14) & 16383) + 1 ))"
    return 0
  fi
  if [ "${fcc}" = "86805688" ]; then          # 'VP8X'：21 flags，22-24 保留，25-27 宽-1，28-30 高-1
    echo "$(( (${25} | (${26} << 8) | (${27} << 16)) + 1 ))x$(( (${28} | (${29} << 8) | (${30} << 16)) + 1 ))"
    return 0
  fi
  if [ "${fcc}" = "86805632" ]; then          # 'VP8 '（有损）：21-23 frame tag，24-26 sync，27-28 宽，29-30 高（各 14 位）
    echo "$(( (${27} | (${28} << 8)) & 16383 ))x$(( (${29} | (${30} << 8)) & 16383 ))"
    return 0
  fi
  return 1
}

# ---------- JSON 读取（macOS: plutil 真解析；有 python3 时用之；否则降级 grep 并标注） ----------
JSON_MODE="降级(grep)"
if [ "${USE_PLUTIL}" = "1" ]; then JSON_MODE="plutil"; elif [ -n "${PY}" ]; then JSON_MODE="python3"; fi

json_valid() {  # 0 = 合法
  if [ "${USE_PLUTIL}" = "1" ]; then
    plutil -convert xml1 -o /dev/null "$1" >/dev/null 2>&1
  elif [ -n "${PY}" ]; then
    "${PY}" -c 'import json,sys;json.load(open(sys.argv[1],encoding="utf-8"))' "$1" >/dev/null 2>&1
  else
    grep -q '^[[:space:]]*{' "$1" 2>/dev/null
  fi
}

json_raw() {  # $1=file $2=key → 字符串/数字（无则空）
  if [ "${USE_PLUTIL}" = "1" ]; then
    plutil -extract "$2" raw -o - "$1" 2>/dev/null || true
  elif [ -n "${PY}" ]; then
    "${PY}" -c 'import json,sys
try:
    d=json.load(open(sys.argv[1],encoding="utf-8"))
except Exception:
    sys.exit(0)
v=d.get(sys.argv[2],"") if isinstance(d,dict) else ""
print("" if v is None else v)' "$1" "$2" 2>/dev/null || true
  else
    sed -n "s/.*\"$2\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$1" | head -1
  fi
}

json_has_key() {  # $1=file $2=key
  if [ "${USE_PLUTIL}" = "1" ]; then
    plutil -extract "$2" raw -o - "$1" >/dev/null 2>&1
  elif [ -n "${PY}" ]; then
    "${PY}" -c 'import json,sys
try:
    d=json.load(open(sys.argv[1],encoding="utf-8"))
except Exception:
    sys.exit(1)
sys.exit(0 if isinstance(d,dict) and sys.argv[2] in d else 1)' "$1" "$2" >/dev/null 2>&1
  else
    grep -q "\"$2\"[[:space:]]*:" "$1" 2>/dev/null
  fi
}

hash16() {
  if have sha256sum; then sha256sum "$1" | cut -c1-16; else shasum -a 256 "$1" | cut -c1-16; fi
}

assert_plain() {  # 拒绝符号链接与特殊文件（目标存在时才检查）
  p="$1"; what="$2"
  [ -e "${p}" ] || [ -L "${p}" ] || return 0
  if [ -L "${p}" ]; then
    echo "  ✗ ${what} 是符号链接（-> $(readlink "${p}")）—— 拒绝写入/备份，避免 cp 跟随链接写到目标之外" >&2
    return 1
  fi
  if [ ! -d "${p}" ] && [ ! -f "${p}" ]; then
    echo "  ✗ ${p} 不是普通文件或目录（特殊文件）—— 拒绝操作" >&2
    return 1
  fi
  return 0
}

echo "变体: ${LABEL}"
echo "来源: ${SRC}"
echo "目标: ${PETS}"
echo "校验方式: JSON=${JSON_MODE}  图集尺寸=内置解析  哈希=$(have sha256sum && echo sha256sum || echo shasum)"
echo

# ---------- ② 只读预检 ----------
preflight_fail=0
candidates=0
ids=""
conflicts=""
for pack in "${SRC}"/*/; do
  [ -f "${pack}/pet.json" ] || continue
  candidates=$((candidates + 1))
  id="$(basename "${pack}")"
  sheet="${pack}/spritesheet.webp"
  manifest="${pack}/pet.json"

  if [ ! -f "${sheet}" ]; then
    echo "  ✗ ${id}: 缺少 spritesheet.webp" >&2; preflight_fail=1; continue
  fi
  bytes="$(wc -c < "${sheet}" | tr -d ' ')"
  if [ "${bytes}" -lt 100000 ] || [ "${bytes}" -gt 20971520 ]; then
    echo "  ✗ ${id}: 图集体积异常（${bytes} 字节，预期 100KB–20MiB）" >&2; preflight_fail=1; continue
  fi
  size="$(webp_size "${sheet}" || true)"
  if [ -z "${size}" ]; then
    echo "  ✗ ${id}: 不是可解析的 WebP（RIFF/WEBP 结构或尺寸读取失败）" >&2; preflight_fail=1; continue
  fi
  want_size="1536x2288"; [ "${WANT_V}" = "1" ] && want_size="1536x1872"
  if [ "${size}" != "${want_size}" ]; then
    echo "  ✗ ${id}: 图集尺寸 ${size}，应为 ${want_size}" >&2; preflight_fail=1; continue
  fi

  if ! json_valid "${manifest}"; then
    echo "  ✗ ${id}: pet.json 不是合法 JSON" >&2; preflight_fail=1; continue
  fi
  mid="$(json_raw "${manifest}" id)"
  mpath="$(json_raw "${manifest}" spritesheetPath)"
  mname="$(json_raw "${manifest}" displayName)"
  mdesc="$(json_raw "${manifest}" description)"
  if [ "${mid}" != "${id}" ]; then
    echo "  ✗ ${id}: pet.json 的 id=${mid} 与目录名不符" >&2; preflight_fail=1; continue
  fi
  if [ "${mpath}" != "spritesheet.webp" ]; then
    echo "  ✗ ${id}: spritesheetPath=${mpath}，应为 spritesheet.webp" >&2; preflight_fail=1; continue
  fi
  [ -n "${mname}" ] || { echo "  ✗ ${id}: displayName 缺失" >&2; preflight_fail=1; continue; }
  [ -n "${mdesc}" ] || { echo "  ✗ ${id}: description 缺失" >&2; preflight_fail=1; continue; }

  if json_has_key "${manifest}" spriteVersionNumber; then
    sver="$(json_raw "${manifest}" spriteVersionNumber)"
    if [ "${WANT_V}" = "2" ]; then
      if [ "${sver}" != "2" ]; then
        echo "  ✗ ${id}: spriteVersionNumber=${sver}，v2 要求整数 2" >&2; preflight_fail=1; continue
      fi
    else
      echo "  ✗ ${id}: v1 不应含 spriteVersionNumber（现值 ${sver}）" >&2; preflight_fail=1; continue
    fi
  elif [ "${WANT_V}" = "2" ]; then
    echo "  ✗ ${id}: 缺少 spriteVersionNumber（v2 必需）" >&2; preflight_fail=1; continue
  fi

  # 已安装同名宠物：拒绝链接；版式不同需 --force
  conflict=""
  if [ -e "${PETS}/${id}" ] || [ -L "${PETS}/${id}" ]; then
    assert_plain "${PETS}/${id}" "已安装目录 ${id}" || { preflight_fail=1; continue; }
    assert_plain "${PETS}/${id}/pet.json" "${id}/pet.json" || { preflight_fail=1; continue; }
    assert_plain "${PETS}/${id}/spritesheet.webp" "${id}/spritesheet.webp" || { preflight_fail=1; continue; }
    if [ -f "${PETS}/${id}/pet.json" ]; then
      if json_has_key "${PETS}/${id}/pet.json" spriteVersionNumber; then have_v=2; else have_v=1; fi
      if [ "${have_v}" != "${WANT_V}" ]; then
        conflict="已安装的是 v${have_v}，本次要装 v${WANT_V}"
        if [ "${FORCE}" != "1" ]; then
          echo "  ✗ ${id}: ${conflict} —— 拒绝覆盖（确认要换版式请加 --force）" >&2
          preflight_fail=1; continue
        fi
      fi
    fi
  fi

  ids="${ids} ${id}"
  conflicts="${conflicts} ${id}=${conflict:-none}"
done

if [ "${candidates}" = "0" ]; then
  echo "  ✗ ${SRC} 下没有找到任何宠物包（*/pet.json）" >&2
  exit 1
fi
if [ "${preflight_fail}" != "0" ]; then
  echo
  echo "  预检未通过（${candidates} 个候选包），未做任何改动 ✗" >&2
  exit 1
fi

# ---------- ③ 唯一备份目录 ----------
mkdir -p "${PETS}"
BACKUP_BASE="${CODEX_HOME}/pets_backup-$(date +%Y%m%d-%H%M%S)"
BACKUP="${BACKUP_BASE}"
n=1
while [ -e "${BACKUP}" ]; do
  BACKUP="${BACKUP_BASE}-${n}"
  n=$((n + 1))
  if [ "${n}" -gt 100 ]; then echo "  ✗ 无法创建唯一备份目录" >&2; exit 1; fi
done
mkdir -p "${BACKUP}"

# ---------- ④ 备份 + 就地安装（逐套报告状态） ----------
installed=0
failed=0
echo "  备份目录: ${BACKUP}"
for id in ${ids}; do
  pack="${SRC}/${id}"
  if [ -e "${PETS}/${id}" ]; then
    if ! cp -R "${PETS}/${id}" "${BACKUP}/${id}"; then
      echo "  ✗ ${id}: 备份失败，跳过（未改动该宠物）" >&2; failed=$((failed + 1)); continue
    fi
  fi
  if ! mkdir -p "${PETS}/${id}" \
     || ! cp "${pack}/pet.json" "${PETS}/${id}/pet.json" \
     || ! cp "${pack}/spritesheet.webp" "${PETS}/${id}/spritesheet.webp"; then
    echo "  ✗ ${id}: 复制失败（备份在 ${BACKUP}/${id}，请据此恢复）" >&2
    failed=$((failed + 1)); continue
  fi
  installed=$((installed + 1))
  note=""
  for entry in ${conflicts}; do
    if [ "${entry%%=*}" = "${id}" ] && [ "${entry#*=}" != "none" ]; then
      note="${entry#*=}"
    fi
  done
  if [ -n "${note}" ]; then
    echo "  ✓ ${id}（强制换版式：${note}）"
  else
    echo "  ✓ ${id}"
  fi
done

echo
echo "  已安装 ${installed} 套、失败 ${failed} 套（变体: ${LABEL}）到 ${PETS}"
[ "${failed}" != "0" ] && echo "  ⚠️ 有失败项：已完成的是本变体，失败项保持原状或被部分更新，备份见上" >&2
echo "  备份: ${BACKUP}（未被覆盖的宠物不会出现在这里）"
echo "  校验值（sha256 前 16 位，可与 dist/ 下同名文件比对）:"
for id in ${ids}; do
  [ -f "${PETS}/${id}/spritesheet.webp" ] || continue
  digest="$(hash16 "${PETS}/${id}/spritesheet.webp" 2>/dev/null || echo '(取哈希失败)')"
  printf "    %s  %s\n" "${digest}" "${id}/spritesheet.webp"
done
echo "  下一步: 重启 ChatGPT 应用（原 Codex 桌面端已并入）→ 设置 → Pets → Refresh 后选择宠物"
[ "${failed}" != "0" ] && exit 1
exit 0
