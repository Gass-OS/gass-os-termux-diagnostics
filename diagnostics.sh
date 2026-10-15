#!/data/data/com.termux/files/usr/bin/bash
# GASS-OS Termux Diagnostics — read-only local system snapshot.
set -u

OUTPUT="${1:-}"
if [[ -z "$OUTPUT" ]]; then
  mkdir -p reports
  OUTPUT="reports/diagnostics-$(date +%Y%m%d-%H%M%S).txt"
else
  parent="$(dirname "$OUTPUT")"
  mkdir -p "$parent"
fi

have() { command -v "$1" >/dev/null 2>&1; }
section() { printf '\n===== %s =====\n' "$1"; }

{
  echo "GASS-OS Termux Diagnostics"
  echo "Generated: $(date 2>/dev/null || echo unknown)"
  echo "Privacy: local report; inspect before sharing."

  section "Platform"
  printf 'uname: '; uname -a 2>/dev/null || true
  printf 'architecture: '; uname -m 2>/dev/null || true
  printf 'PREFIX: %s\n' "${PREFIX:-not set}"
  printf 'HOME: %s\n' "${HOME:-not set}"
  printf 'TERMUX_VERSION: %s\n' "${TERMUX_VERSION:-not set}"
  printf 'ANDROID_ROOT: %s\n' "${ANDROID_ROOT:-not set}"
  printf 'ANDROID_DATA: %s\n' "${ANDROID_DATA:-not set}"

  section "Available tools"
  for cmd in bash pkg apt dpkg git python python3 clang make cmake \
             termux-info termux-x11 glxinfo eglinfo vulkaninfo; do
    if have "$cmd"; then printf '%-14s %s\n' "$cmd" "$(command -v "$cmd")"
    else printf '%-14s %s\n' "$cmd" "not found"; fi
  done

  section "Storage"
  if have df; then df -h "${HOME:-.}" 2>&1 | head -n 5; else echo "df unavailable"; fi

  section "Memory"
  if [[ -r /proc/meminfo ]]; then
    grep -E '^(MemTotal|MemFree|MemAvailable|SwapTotal|SwapFree):' /proc/meminfo || true
  else
    echo "/proc/meminfo unavailable"
  fi

  section "Graphics-related environment"
  env | sort | grep -E '^(DISPLAY|WAYLAND_DISPLAY|XDG_RUNTIME_DIR|MESA_|GALLIUM_|LIBGL_|EGL_|VK_|TERMUX_X11)' || \
    echo "No matching graphics variables are set."

  section "Termux package hints"
  if have dpkg; then
    dpkg -l 2>/dev/null | awk '/^ii/ && $2 ~ /(mesa|x11|gnome|mutter|pulseaudio|vulkan)/ {print $2, $3}' | head -n 40
  else
    echo "dpkg unavailable"
  fi
} > "$OUTPUT" 2>&1

printf 'Report written to: %s\n' "$OUTPUT"
printf 'Please review and redact sensitive details before sharing it.\n'
