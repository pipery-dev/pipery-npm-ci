#!/usr/bin/env psh
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"

echo "==> Package: running 'npm pack' in ${PROJECT}"
cd "${PROJECT}"
npm pack
printf '{"event":"package","status":"success","tool":"npm-pack"}\n' >> "${LOG}"
