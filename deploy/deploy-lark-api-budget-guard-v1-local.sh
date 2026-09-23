#!/bin/sh
set -eu
REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-lark-api-budget-guard-v1.0.0.zip"
STAGE="$DEPLOY/lark-api-budget-guard-stage"
EXPECTED="5e50269aedf002160088f39749d847f44f4dd9b4f2d05354683a77a7d1967a36"

echo "[1/4] Verify package..."
test -f "$ZIP" || { echo "ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[2/4] Stage..."
rm -rf "$STAGE"; mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-lark-api-budget-guard-v1.0.0"
(cd "$PKG" && sha256sum -c MANIFEST.sha256)

echo "[3/4] Install..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[4/4] Done"
echo "MERLY LARK API BUDGET GUARD V1 DEPLOY VERIFIED OK"
