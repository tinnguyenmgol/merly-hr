#!/bin/sh
set -eu
REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-emergency-local-login-v1.0.0.zip"
STAGE="$DEPLOY/emergency-local-login-stage"
EXPECTED="24f4f1f44c45d28fc02db6b7a97c727954f54ec33b4180b99c78792cfe81e394"

echo "[1/4] Verify package..."
test -f "$ZIP" || { echo "ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[2/4] Stage..."
rm -rf "$STAGE"; mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-hr-emergency-local-login-v1.0.0"
(cd "$PKG" && sha256sum -c MANIFEST.sha256)

echo "[3/4] Install..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[4/4] Done"
echo "MERLY HR EMERGENCY LOCAL LOGIN V1 DEPLOY VERIFIED OK"
