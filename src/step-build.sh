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

# Check if psh is usable (installed and executable on this platform)
_psh_usable() {
  command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1
}

# Check if build script exists in package.json
if [ -f "${PROJECT}/package.json" ] && command -v node >/dev/null 2>&1; then
  HAS_BUILD=$(node -e "const p=require('${PROJECT}/package.json'); process.exit(p.scripts && p.scripts.build ? 0 : 1);" 2>/dev/null && echo "yes" || echo "no")
else
  HAS_BUILD="no"
fi

if [ "${HAS_BUILD}" = "yes" ]; then
  echo "==> Build: running '${PM} run build'"
  if _psh_usable; then
    psh -log-file "${LOG}" -fail-on-error -c "cd ${PROJECT} && ${PM} run build"
  else
    cd "${PROJECT}" && ${PM} run build
    printf '{"event":"build_step","status":"success","tool":"%s"}\n' "${PM}" >> "${LOG}"
  fi
else
  echo "==> Build: no build script found in package.json; skipping"
  printf '{"event":"build_step","status":"skipped","reason":"no_build_script"}\n' >> "${LOG}"
fi
