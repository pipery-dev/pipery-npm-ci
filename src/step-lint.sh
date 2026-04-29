#!/usr/bin/env psh
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"

ESLINT_CONFIG=$(find "${PROJECT}" -maxdepth 1 \( -name ".eslintrc*" -o -name "eslint.config.*" \) 2>/dev/null | head -1)

if [ -n "${ESLINT_CONFIG}" ]; then
  echo "==> Lint: ESLint config found at ${ESLINT_CONFIG}"
  npx eslint "${PROJECT}" --max-warnings=0
  printf '{"event":"lint","status":"success","tool":"eslint"}\n' >> "${LOG}"
else
  echo "==> Lint: no ESLint config found; skipping gracefully"
  printf '{"event":"lint","status":"skipped","reason":"no_eslint_config"}\n' >> "${LOG}"
fi
