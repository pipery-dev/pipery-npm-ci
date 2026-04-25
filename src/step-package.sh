#!/usr/bin/env bash
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

# Check if psh is usable (installed and executable on this platform)
_psh_usable() {
  command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1
}

echo "==> Package: running 'npm pack' in ${PROJECT}"
cd "${PROJECT}"
if _psh_usable; then
  psh -log-file "${LOG}" -fail-on-error -c "npm pack"
else
  npm pack
  printf '{"event":"package","status":"success","tool":"npm-pack"}\n' >> "${LOG}"
fi
