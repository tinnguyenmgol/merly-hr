#!/bin/sh
set -eu
REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-lark-api-budget-guard-v1.0.1.zip"
STAGE="$DEPLOY/lark-api-budget-guard-v101-stage"
EXPECTED="6279019ce79ac40a9a50e7317195d1555e873735d590a705c31ba36dd51b414b"

echo "[1/4] Verify package..."
test -f "$ZIP" || { echo "ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[2/4] Stage..."
rm -rf "$STAGE"; mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-lark-api-budget-guard-v1.0.1"
(cd "$PKG" && sha256sum -c MANIFEST.sha256)

echo "[3/4] Install..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[4/4] Done"
echo "MERLY LARK API BUDGET GUARD V1.0.1 DEPLOY VERIFIED OK"
