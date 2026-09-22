#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-core-v3-p3.3.zip"
STAGE="$DEPLOY/core-p33-stage"
EXPECTED="78d5a2d572712ec18cad147965b6a13545248b35084d213727b810a2010b9832"

echo "[deploy 1/6] Verify P3.3 package..."
test -f "$ZIP" || { echo "P3.3 ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "P3.3 CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/6] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-hr-core-v3-p3.3"
test -f "$PKG/install.sh"

echo "[deploy 3/6] Verify manifest + syntax..."
(cd "$PKG" && sha256sum -c MANIFEST.sha256)
sh -n "$PKG/install.sh"
find "$PKG/private" -type f -name '*.php' -print | while IFS= read -r f; do /usr/bin/php -l "$f" >/dev/null; done
if command -v node >/dev/null 2>&1; then node --check "$PKG/public_html/hr/assets/self-review.js" >/dev/null; fi

echo "[deploy 4/6] Install Core v3 P3.3..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[deploy 5/6] Post-deploy verification..."
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/p33_selftest.php"
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/self_review_selftest.php"
/usr/bin/php -l "$ROOT/private/cron/sync_sales_kpi.php" >/dev/null
if command -v node >/dev/null 2>&1; then node --check "$ROOT/public_html/hr/assets/app.js" >/dev/null; node --check "$ROOT/public_html/hr/assets/self-review.js" >/dev/null; fi

echo "[deploy 6/6] Done"
echo "MERLY HR CORE V3 P3.3 DEPLOY VERIFIED OK"
