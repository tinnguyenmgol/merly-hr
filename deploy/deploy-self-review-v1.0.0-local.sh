#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-monthly-self-review-v1.0.0.zip"
STAGE="$DEPLOY/monthly-self-review-v1-stage"
EXPECTED="350b5031c74a0044d08a4455ff8d68200bc01de6edd7fd7a0d95233835c5a5cc"

echo "[deploy 1/6] Verify package..."
test -f "$ZIP" || { echo "SELF REVIEW ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "SELF REVIEW CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/6] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-monthly-self-review-v1.0.0"
test -f "$PKG/install.sh"

echo "[deploy 3/6] Verify manifest + syntax..."
(cd "$PKG" && sha256sum -c MANIFEST.sha256)
sh -n "$PKG/install.sh"
find "$PKG/private" "$PKG/public_html" -type f -name '*.php' -print | while IFS= read -r f; do /usr/bin/php -l "$f" >/dev/null; done
if command -v node >/dev/null 2>&1; then node --check "$PKG/public_html/hr/assets/self-review.js" >/dev/null; fi

echo "[deploy 4/6] Install Monthly Self Review..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[deploy 5/6] Post-deploy verification..."
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/self_review_selftest.php"
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/self_review_setup.php"
/usr/bin/php -l "$ROOT/public_html/hr/self-review-api.php" >/dev/null
/usr/bin/php -l "$ROOT/public_html/hr/index.php" >/dev/null
[ "$(grep -o '/hr/assets/self-review.css' "$ROOT/public_html/hr/index.php" | wc -l)" -eq 1 ]
[ "$(grep -o '/hr/assets/self-review.js' "$ROOT/public_html/hr/index.php" | wc -l)" -eq 1 ]

echo "[deploy 6/6] Done"
echo "MERLY MONTHLY SELF REVIEW V1.0.0 DEPLOY VERIFIED OK"
