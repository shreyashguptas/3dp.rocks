#!/usr/bin/env bash
# Serve the lithophane app locally and open it in the default browser.
#
# The app MUST be served over http:// — opening index.html directly as a
# file:// URL fails silently, because the browser blocks the page from
# fetching its own settings file (data/layout.json) from disk.
#
# Usage:  ./run.sh [port]        (default port 8777)

set -euo pipefail

PORT="${1:-8777}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
URL="http://localhost:${PORT}/lithophane/index.html"

if lsof -nP -iTCP:"${PORT}" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Port ${PORT} is already in use. Try:  ./run.sh 8888"
  exit 1
fi

echo "Serving ${ROOT} on port ${PORT}"
echo "Opening ${URL}"
echo "Press Ctrl+C to stop the server."

python3 -m http.server "${PORT}" --directory "${ROOT}" >/dev/null 2>&1 &
SERVER_PID=$!
trap 'kill "${SERVER_PID}" 2>/dev/null || true' EXIT INT TERM

sleep 1
open "${URL}"
wait "${SERVER_PID}"
