#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-core-v3-p3.4.zip"
STAGE="$DEPLOY/core-p34-stage"
EXPECTED="e38c87401375ddc1fddef247902bb4f777d97ead3384ee243e649730d4029f74"

echo "[deploy 1/6] Verify P3.4 package..."
test -f "$ZIP" || { echo "P3.4 ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "P3.4 CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/6] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-hr-core-v3-p3.4"
test -f "$PKG/install.sh"

echo "[deploy 3/6] Verify manifest + syntax..."
(cd "$PKG" && sha256sum -c MANIFEST.sha256)
sh -n "$PKG/install.sh"
find "$PKG/private" -type f -name '*.php' -print | while IFS= read -r f; do /usr/bin/php -l "$f" >/dev/null; done
if command -v node >/dev/null 2>&1; then node --check "$PKG/public_html/hr/assets/self-review.js" >/dev/null; fi

echo "[deploy 4/6] Install Core v3 P3.4..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[deploy 5/6] Post-deploy verification..."
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/p34_selftest.php"
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/self_review_selftest.php"
if command -v node >/dev/null 2>&1; then node --check "$ROOT/public_html/hr/assets/app.js" >/dev/null; node --check "$ROOT/public_html/hr/assets/self-review.js" >/dev/null; fi

echo "[deploy 6/6] Done"
echo "MERLY HR CORE V3 P3.4 DEPLOY VERIFIED OK"
