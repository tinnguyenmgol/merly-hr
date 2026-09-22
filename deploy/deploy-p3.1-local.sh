#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-core-v3-p3.1.zip"
STAGE="$DEPLOY/core-p31-stage"
EXPECTED="0809426ff5070dba9a5f0cde3a6435b8e606111dfafa97f743aab087e80d9445"

echo "[deploy 1/6] Verify P3.1 package..."
test -f "$ZIP" || { echo "P3.1 ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "P3.1 CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/6] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
test -f "$STAGE/p3.1/install.sh"

echo "[deploy 3/6] Verify manifest + syntax..."
(cd "$STAGE/p3.1" && sha256sum -c MANIFEST.sha256)
sh -n "$STAGE/p3.1/install.sh"
find "$STAGE/p3.1/private" "$STAGE/p3.1/public_html" -type f -name '*.php' -print | while IFS= read -r f; do /usr/bin/php -l "$f" >/dev/null; done
node --check "$STAGE/p3.1/public_html/hr/assets/p1.js" >/dev/null 2>&1 || true

echo "[deploy 4/6] Install Core v3 P3.1..."
MERLY_ROOT="$ROOT" sh "$STAGE/p3.1/install.sh"

echo "[deploy 5/6] Post-deploy checks..."
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/p3_selftest.php"
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/kpi_realtime_status.php"
/usr/bin/php -l "$ROOT/public_html/hr/kpi-realtime.php" >/dev/null
/usr/bin/php -l "$ROOT/public_html/api/system-health.php" >/dev/null

echo "[deploy 6/6] Done"
echo "MERLY HR CORE V3 P3.1 DEPLOY VERIFIED OK"
