#!/usr/bin/env bash
# Optional helper when system libwebkit2gtk-4.1-dev is not installed.
# Usually unnecessary — linux/CMakeLists.txt auto-detects ~/.local/webkit-*.
set -euo pipefail
export PKG_CONFIG_PATH="${HOME}/.local/webkit-pc${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
export LIBRARY_PATH="${HOME}/.local/webkit-prefix/usr/lib/x86_64-linux-gnu${LIBRARY_PATH:+:$LIBRARY_PATH}"
if [[ -x "${HOME}/flutter/bin/flutter" ]]; then
  export PATH="${HOME}/flutter/bin:${PATH}"
fi
exec flutter "$@"
