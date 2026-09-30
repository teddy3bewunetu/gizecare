#!/usr/bin/env bash
# Re-apply after `flutter pub get` (pub-cache resets package sources).
# Allows Quill link TextSpans to show a pointer cursor while editing.
set -euo pipefail
TARGET="$(find "${HOME}/.pub-cache/hosted" -path '*flutter_quill-11.*/lib/src/editor/raw_editor/raw_editor_state.dart' 2>/dev/null | sort | tail -1 || true)"
if [[ -z "${TARGET}" || ! -f "${TARGET}" ]]; then
  echo "flutter_quill raw_editor_state.dart not found in pub-cache"
  exit 0
fi
if grep -q 'GizeCare: patched' "${TARGET}"; then
  echo "Already patched: ${TARGET}"
  exit 0
fi
python3 - "$TARGET" <<'PY'
import pathlib, sys
path = pathlib.Path(sys.argv[1])
text = path.read_text()
variants = [
    (
        "cursor: widget.config.readOnly\n"
        "                      ? widget.config.readOnlyMouseCursor\n"
        "                      : SystemMouseCursors.text,",
        "cursor: widget.config.readOnly\n"
        "                      ? widget.config.readOnlyMouseCursor\n"
        "                      : MouseCursor.defer, // GizeCare: patched",
    ),
    (
        "cursor: widget.config.readOnly\n"
        "                  ? widget.config.readOnlyMouseCursor\n"
        "                  : SystemMouseCursors.text,",
        "cursor: widget.config.readOnly\n"
        "                  ? widget.config.readOnlyMouseCursor\n"
        "                  : MouseCursor.defer, // GizeCare: patched",
    ),
]
count = 0
for old, new in variants:
    if old in text:
        text = text.replace(old, new)
        count += 1
if count == 0:
    raise SystemExit(f"Pattern not found in {path}")
path.write_text(text)
print(f"Patched {count} MouseRegion cursor(s) in {path}")
PY
