#!/usr/bin/env bash
# Seeds fake Room objects in Parse and generates matching QR code PNGs.
# Reads PARSE_APP_ID, PARSE_CLIENT_KEY, PARSE_SERVER_URL from .env at repo root.
#
# NOTE: .env credentials currently point to a different Back4App project
# than lib/main.dart. Rooms created here are only visible to the app if
# main.dart is updated to load these values at runtime.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$REPO_ROOT/.env"
QR_DIR="$REPO_ROOT/test-qr"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: $ENV_FILE not found" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

: "${PARSE_APP_ID:?PARSE_APP_ID not set in .env}"
: "${PARSE_CLIENT_KEY:?PARSE_CLIENT_KEY not set in .env}"
: "${PARSE_SERVER_URL:?PARSE_SERVER_URL not set in .env}"

command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
command -v qrencode >/dev/null || { echo "qrencode is required" >&2; exit 1; }

mkdir -p "$QR_DIR"

# Format: name|qrRoomValue|qrCheckoutValue
rooms=(
  "Conference Room|conference-room-checkin|conference-room-checkout"
  "Library|library-checkin|library-checkout"
  "Break Room|break-room-checkin|break-room-checkout"
  "Lab 101|lab-101-checkin|lab-101-checkout"
)

for entry in "${rooms[@]}"; do
  IFS='|' read -r name checkin checkout <<< "$entry"
  slug=$(echo "$name" | tr '[:upper:] ' '[:lower:]-')

  echo "Creating room: $name"
  payload=$(printf '{"roomName":"%s","qrRoomValue":"%s","qrCheckoutValue":"%s"}' \
    "$name" "$checkin" "$checkout")

  response=$(curl -sS -X POST \
    -H "X-Parse-Application-Id: $PARSE_APP_ID" \
    -H "X-Parse-Client-Key: $PARSE_CLIENT_KEY" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    "$PARSE_SERVER_URL/classes/Room")

  if echo "$response" | grep -q '"objectId"'; then
    object_id=$(echo "$response" | sed -n 's/.*"objectId":"\([^"]*\)".*/\1/p')
    echo "  created objectId=$object_id"
    qrencode -s 10 -m 4 -o "$QR_DIR/${slug}-checkin.png" "$checkin"
    qrencode -s 10 -m 4 -o "$QR_DIR/${slug}-checkout.png" "$checkout"
    echo "  qr: $QR_DIR/${slug}-checkin.png"
    echo "  qr: $QR_DIR/${slug}-checkout.png"
  else
    echo "  FAILED: $response" >&2
  fi
done

echo "Done."
