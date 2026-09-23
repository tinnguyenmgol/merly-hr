#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-employee-performance-alert-v1.0.0.zip"
STAGE="$DEPLOY/employee-performance-alert-v1-stage"
EXPECTED="fef423377242e325d0f7699407252467a58ea026dbd140eb8a60d09833675208"

echo "[deploy 1/5] Verify package..."
test -f "$ZIP" || { echo "ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/5] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-employee-performance-alert-v1.0.0"
test -f "$PKG/install.sh"

echo "[deploy 3/5] Verify manifest..."
(cd "$PKG" && sha256sum -c MANIFEST.sha256)
sh -n "$PKG/install.sh"

echo "[deploy 4/5] Install Employee Performance Alert v1..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[deploy 5/5] Done"
echo "MERLY EMPLOYEE PERFORMANCE ALERT V1 DEPLOY VERIFIED OK"
