#!/usr/bin/env bash
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

# Detect package manager
if [ -f "${PROJECT}/yarn.lock" ]; then
  PM="yarn"
else
  PM="npm"
fi

echo "==> Test: running '${PM} test' in ${PROJECT}"
cd "${PROJECT}"

# Check if psh is usable (installed and executable on this platform)
_psh_usable() {
  command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1
}

if _psh_usable; then
  psh -log-file "${LOG}" -fail-on-error -c "${PM} test"
else
  ${PM} test
  printf '{"event":"test","status":"success","tool":"%s"}\n' "${PM}" >> "${LOG}"
fi
