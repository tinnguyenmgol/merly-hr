#!/bin/sh
set -eu
REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-lark-api-efficiency-v2.0.0.zip"
STAGE="$DEPLOY/lark-api-efficiency-v2-stage"
EXPECTED="575473698754f93b958cd3006f4b7c9b807ae7cf762e23c7a358d9a5e105697b"

echo "[1/4] Verify package..."
test -f "$ZIP" || { echo "ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[2/4] Stage..."
rm -rf "$STAGE"; mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-lark-api-efficiency-v2.0.0"
(cd "$PKG" && sha256sum -c MANIFEST.sha256)

echo "[3/4] Install..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[4/4] Done"
echo "MERLY LARK API EFFICIENCY V2 DEPLOY VERIFIED OK"
