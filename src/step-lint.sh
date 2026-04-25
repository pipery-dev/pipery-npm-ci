#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

# Check if psh is usable (installed and executable on this platform)
_psh_usable() {
  command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1
}

# Check for ESLint config
ESLINT_CONFIG=$(ls "${PROJECT}"/.eslintrc* "${PROJECT}"/eslint.config.* 2>/dev/null | head -1 || true)

if [ -n "${ESLINT_CONFIG}" ]; then
  echo "==> Lint: ESLint config found at ${ESLINT_CONFIG}"
  if _psh_usable; then
    psh -log-file "${LOG}" -fail-on-error -c "npx eslint ${PROJECT} --max-warnings=0"
  else
    npx eslint "${PROJECT}" --max-warnings=0
    printf '{"event":"lint","status":"success","tool":"eslint"}\n' >> "${LOG}"
  fi
else
  echo "==> Lint: no ESLint config found; skipping gracefully"
  printf '{"event":"lint","status":"skipped","reason":"no_eslint_config"}\n' >> "${LOG}"
fi
