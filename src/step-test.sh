#!/usr/bin/env bash
set -euo pipefail

PROJECT="${INPUT_PROJECT_PATH:-.}"
LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
TESTS_PATH="${INPUT_TESTS_PATH:-}"

# Detect package manager
if [ -f "${PROJECT}/yarn.lock" ]; then
  PM="yarn"
else
  PM="npm"
fi

TEST_CMD="${PM} test"
[ -n "$TESTS_PATH" ] && TEST_CMD="${PM} test -- ${TESTS_PATH}"

echo "==> Test: running '${TEST_CMD}' in ${PROJECT}"
cd "${PROJECT}"

# Check if psh is usable (installed and executable on this platform)
_psh_usable() {
  command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1
}

if _psh_usable; then
  psh -log-file "${LOG}" -fail-on-error -c "${TEST_CMD}"
else
  ${PM} test ${TESTS_PATH:+-- "$TESTS_PATH"}
  printf '{"event":"test","status":"success","tool":"%s"}\n' "${PM}" >> "${LOG}"
fi
