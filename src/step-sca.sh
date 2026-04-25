#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

# Check if psh is usable (installed and executable on this platform)
_psh_usable() {
  command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1
}

if command -v pipery-steps >/dev/null 2>&1; then
  pipery-steps sca --language javascript --project-path "${PROJECT}" --log-file "${LOG}"
elif command -v npm >/dev/null 2>&1 && _psh_usable; then
  echo "==> SCA: pipery-steps not found; running npm audit directly"
  psh -log-file "${LOG}" -fail-on-error -c "cd ${PROJECT} && npm audit --audit-level=high"
elif command -v npm >/dev/null 2>&1; then
  echo "==> SCA: running npm audit (no psh)"
  cd "${PROJECT}" && npm audit --audit-level=high
  printf '{"event":"sca","status":"success","tool":"npm-audit"}\n' >> "${LOG}"
else
  echo "==> SCA: no tool available (pipery-steps, npm); skipping gracefully"
  printf '{"event":"sca","status":"skipped","reason":"no_tool"}\n' >> "${LOG}"
fi
