#!/bin/sh
set -eu

REPO=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
DEPLOY=$(dirname "$REPO")
ROOT=$(dirname "$DEPLOY")
BASE="$REPO/snapshots/merly-hr-core-v3-p2.zip"
STAGE="$DEPLOY/core-p202-stage"
EXPECTED="ada6fd843156e6f26105f937259396d9568a3117ad17590c98a259b1b66f3a59"

echo "[deploy 1/7] Verify repository + baseline snapshot..."
test -f "$BASE"
ACTUAL=$(sha256sum "$BASE" | awk '{print $1}')
[ "$ACTUAL" = "$EXPECTED" ] || { echo "BASE P2 CHECKSUM FAIL: $ACTUAL" >&2; exit 1; }

echo "[deploy 2/7] Build clean P2.0.2 staging..."
rm -rf "$STAGE"
mkdir -p "$STAGE"
unzip -q "$BASE" -d "$STAGE"
cp "$REPO/releases/p2.0.2/install.sh" "$STAGE/install.sh"
cp "$REPO/hotfixes/p2.0.1/private/tools/register_governance_jobs.php" "$STAGE/private/tools/register_governance_jobs.php"
chmod +x "$STAGE/install.sh"

echo "[deploy 3/7] Regenerate package manifest..."
(
  cd "$STAGE"
  find . -type f ! -name MANIFEST.sha256 -print0 | sort -z | xargs -0 sha256sum > MANIFEST.sha256
  sha256sum -c MANIFEST.sha256
)

echo "[deploy 4/7] Preflight shell + PHP syntax..."
sh -n "$STAGE/install.sh"
find "$STAGE/private" "$STAGE/public_html" -type f -name '*.php' -print | while IFS= read -r f; do /usr/bin/php -l "$f" >/dev/null; done

echo "[deploy 5/7] Install to production root: $ROOT"
MERLY_ROOT="$ROOT" sh "$STAGE/install.sh"

echo "[deploy 6/7] Post-install self-test..."
MERLY_ROOT="$ROOT" /usr/bin/php "$ROOT/private/tools/p2_selftest.php"
/usr/bin/php -l "$ROOT/public_html/api/healthz.php"
/usr/bin/php -l "$ROOT/public_html/hr/governance.php"

echo "[deploy 7/7] Done"
echo "MERLY HR CORE V3 P2.0.2 DEPLOY VERIFIED OK"
