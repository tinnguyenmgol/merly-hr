#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
ZIP="$DEPLOY/merly-hr-core-v3-p3.zip"
STAGE="$DEPLOY/core-p3-stage"
EXPECTED="afd83e67480dfa7150eb2f153d391dfa82af9ab9d34d10c73a60527d9df33ae2"

echo "[deploy 1/6] Verify P3 package..."
test -f "$ZIP" || { echo "P3 ZIP MISSING: $ZIP" >&2; exit 1; }
ACTUAL=$(sha256sum "$ZIP" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "P3 CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/6] Build clean staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$ZIP" -d "$STAGE"
test -f "$STAGE/p3/install.sh"

echo "[deploy 3/6] Verify manifest + syntax..."
(cd "$STAGE/p3" && sha256sum -c MANIFEST.sha256)
sh -n "$STAGE/p3/install.sh"
find "$STAGE/p3/private" "$STAGE/p3/public_html" -type f -name '*.php' -print | while IFS= read -r f; do /usr/bin/php -l "$f" >/dev/null; done

echo "[deploy 4/6] Install Core v3 P3..."
MERLY_ROOT="$ROOT" sh "$STAGE/p3/install.sh"

echo "[deploy 5/6] Post-deploy checks..."
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/kpi_realtime_status.php"
/usr/bin/php -l "$ROOT/public_html/hr/kpi-realtime.php" >/dev/null
/usr/bin/php -l "$ROOT/public_html/api/system-health.php" >/dev/null

echo "[deploy 6/6] Done"
echo "MERLY HR CORE V3 P3 DEPLOY VERIFIED OK"
