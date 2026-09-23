#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-v3.0-rc1-hardening.zip"
STAGE="$DEPLOY/v3-rc1-hardening-stage"
EXPECTED="8b4546e5378feddc376670b3e5d5a111329f1779e2f798ae0fece7825790cfef"

echo "[deploy 1/5] Verify RC1 package..."
test -f "$ZIP" || { echo "RC1 ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "RC1 CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/5] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-hr-v3.0-rc1-hardening"
test -f "$PKG/install.sh"

echo "[deploy 3/5] Verify manifest..."
(cd "$PKG" && sha256sum -c MANIFEST.sha256)
sh -n "$PKG/install.sh"

echo "[deploy 4/5] Install hardening RC1..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[deploy 5/5] Stage post-deploy audit tools..."
cp "$PKG/audit/system-audit-v3.1.php" "$DEPLOY/merly-hr-system-audit-v3.1.php"
cp "$PKG/audit/capture-production-source-v3.1.sh" "$DEPLOY/merly-hr-capture-production-source-v3.1.sh"
chmod 700 "$DEPLOY/merly-hr-capture-production-source-v3.1.sh"

echo "MERLY HR V3.0 RC1 HARDENING DEPLOY VERIFIED OK"
echo "Next: MERLY_ROOT=$ROOT /usr/bin/php $DEPLOY/merly-hr-system-audit-v3.1.php --human"
