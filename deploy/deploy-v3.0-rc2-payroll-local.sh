#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-v3.0-rc2-payroll.zip"
STAGE="$DEPLOY/v3-rc2-payroll-stage"
EXPECTED="a4caf7fc58e9892c9554fcc7002a192bb8fa00fc4c8e29c4cda5e5c9fd21c98d"

echo "[deploy 1/5] Verify RC2 package..."
test -f "$ZIP" || { echo "RC2 ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "RC2 CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/5] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-hr-v3.0-rc2-payroll"
test -f "$PKG/install.sh"

echo "[deploy 3/5] Verify manifest..."
(cd "$PKG" && sha256sum -c MANIFEST.sha256)
sh -n "$PKG/install.sh"

echo "[deploy 4/5] Install PAYROLL-v1.2..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[deploy 5/5] Done"
echo "MERLY HR V3.0 RC2 PAYROLL DEPLOY VERIFIED OK"
