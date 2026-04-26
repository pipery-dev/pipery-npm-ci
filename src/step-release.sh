#!/usr/bin/env bash
set -euo pipefail

LOG="${INPUT_LOG_FILE:-pipery.jsonl}"
PROJECT="${INPUT_PROJECT_PATH:-.}"
SHORT_SHA="${GITHUB_SHA:0:7}"

# Check if psh is usable (installed and executable on this platform)
_psh_usable() {
  command -v psh >/dev/null 2>&1 && psh --version >/dev/null 2>&1
}

if [ -z "${INPUT_NPM_TOKEN:-}" ]; then
  echo "==> Release: no NPM_TOKEN provided; skipping release"
  printf '{"event":"release","status":"skipped","reason":"no_token"}\n' >> "${LOG}"
  exit 0
fi

echo "==> Release: publishing to npm registry"
echo "//registry.npmjs.org/:_authToken=${INPUT_NPM_TOKEN}" >> ~/.npmrc
cd "${PROJECT}"
if _psh_usable; then
  psh -log-file "${LOG}" -fail-on-error -c "npm publish"
else
  npm publish
  printf '{"event":"release","status":"success","tool":"npm-publish"}\n' >> "${LOG}"
fi

# Add sha dist-tag so the exact published build is pinnable by commit
PKG_NAME=$(node -p "require('./package.json').name" 2>/dev/null || true)
PKG_VERSION=$(node -p "require('./package.json').version" 2>/dev/null || true)
if [ -n "$PKG_NAME" ] && [ -n "$PKG_VERSION" ] && [ -n "$SHORT_SHA" ]; then
  npm dist-tag add "${PKG_NAME}@${PKG_VERSION}" "sha-${SHORT_SHA}" 2>/dev/null || true
  echo "==> Added dist-tag sha-${SHORT_SHA} -> ${PKG_NAME}@${PKG_VERSION}"
fi
