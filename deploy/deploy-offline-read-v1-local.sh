#!/bin/sh
set -eu
REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-offline-read-v1.0.0.zip"
STAGE="$DEPLOY/offline-read-v1-stage"
EXPECTED="dc7ba8f3bc87f65c2cd3e065bcd3bb21e8177f470a4666679455aa8ce9c898d1"

echo "[1/4] Verify package..."
test -f "$ZIP" || { echo "ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[2/4] Stage..."
rm -rf "$STAGE"; mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-hr-offline-read-v1.0.0"
(cd "$PKG" && sha256sum -c MANIFEST.sha256)

echo "[3/4] Install..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[4/4] Done"
echo "MERLY HR OFFLINE READ V1 DEPLOY VERIFIED OK"
