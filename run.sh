#!/usr/bin/env bash
# Serve the lithophane app locally and open it in the default browser.
#
# The app MUST be served over http:// — opening index.html directly as a
# file:// URL fails silently, because the browser blocks the page from
# fetching its own settings file (data/layout.json) from disk.
#
# Two deliberate safety choices below:
#   --bind 127.0.0.1   listen on this Mac only. Without it, Python's server
#                      binds every interface, so anyone on the same Wi-Fi
#                      (cafe, hotel, shared office) could reach it.
#   --directory ...    serve ONLY the lithophane folder, never the repo root,
#                      so .git and everything above it are not exposed.
#
# Usage:  ./run.sh [port]        (default port 8777)

set -euo pipefail

PORT="${1:-8777}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVE_DIR="${ROOT}/lithophane"
URL="http://127.0.0.1:${PORT}/index.html"

if [ ! -f "${SERVE_DIR}/index.html" ]; then
  echo "Cannot find ${SERVE_DIR}/index.html — run this from inside the repo."
  exit 1
fi

if lsof -nP -iTCP:"${PORT}" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Port ${PORT} is already in use. Try:  ./run.sh 8888"
  exit 1
fi

echo "Serving ${SERVE_DIR}"
echo "Listening on 127.0.0.1:${PORT} (this Mac only — not visible on your network)"
echo "Opening ${URL}"
echo "Press Ctrl+C to stop the server."

python3 -m http.server "${PORT}" --bind 127.0.0.1 --directory "${SERVE_DIR}" >/dev/null 2>&1 &
SERVER_PID=$!
trap 'kill "${SERVER_PID}" 2>/dev/null || true' EXIT INT TERM

sleep 1
open "${URL}"
wait "${SERVER_PID}"
