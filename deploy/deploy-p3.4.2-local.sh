#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-core-v3-p3.4.2.zip"
STAGE="$DEPLOY/core-p342-stage"
EXPECTED="4a393e9a2fb1b3e5240931260286045053e2a5dceafec8ab30b8667b060eeeec"

echo "[deploy 1/6] Verify P3.4.2 package..."
test -f "$ZIP" || { echo "P3.4.2 ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "P3.4.2 CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/6] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
PKG="$STAGE/merly-hr-core-v3-p3.4.2"
test -f "$PKG/install.sh"

echo "[deploy 3/6] Verify manifest + syntax..."
(cd "$PKG" && sha256sum -c MANIFEST.sha256)
sh -n "$PKG/install.sh"
find "$PKG/private" -type f -name '*.php' -print | while IFS= read -r f; do /usr/bin/php -l "$f" >/dev/null; done

echo "[deploy 4/6] Install Core v3 P3.4.2..."
MERLY_ROOT="$ROOT" sh "$PKG/install.sh"

echo "[deploy 5/6] Post-deploy verification..."
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/p342_selftest.php"
if command -v node >/dev/null 2>&1; then node --check "$ROOT/public_html/hr/assets/app.js" >/dev/null; node --check "$ROOT/public_html/hr/assets/self-review.js" >/dev/null; fi

echo "[deploy 6/6] Done"
echo "MERLY HR CORE V3 P3.4.2 DEPLOY VERIFIED OK"
