#!/bin/sh
set -eu

PKG=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=${MERLY_ROOT:-$(dirname "$PKG")}
ROOT=$(CDPATH= cd -- "$ROOT" && pwd)
PHP=/usr/bin/php
TS=$(date +%Y%m%d_%H%M%S)_$$
BACK="$ROOT/private/backups/core_v3_p2_$TS"
MISSING="$BACK/.missing"

FILES="private/core/AuditLog.php private/governance/policy.php private/governance/ConfigVault.php private/governance/PayrollGovernance.php private/governance/Health.php private/cron/governance_guard.php private/cron/governance_config_backup.php private/tools/governance_backup.php private/tools/governance_restore.php private/tools/payroll_lock_month.php private/tools/payroll_unlock_month.php private/tools/payroll_mark_paid.php private/tools/payroll_month_close.php private/tools/p2_selftest.php private/jobs/jobs_config.php private/ux/ActionCenter.php public_html/api/healthz.php public_html/hr/governance.php public_html/hr/_master_nav.php public_html/hr/assets/p2.css"
RUNTIME_SCAN="private/core/AuditLog.php private/governance/policy.php private/governance/ConfigVault.php private/governance/PayrollGovernance.php private/governance/Health.php private/cron/governance_guard.php private/cron/governance_config_backup.php private/tools/governance_backup.php private/tools/governance_restore.php private/tools/payroll_lock_month.php private/tools/payroll_unlock_month.php private/tools/payroll_mark_paid.php private/tools/payroll_month_close.php private/tools/p2_selftest.php private/ux/ActionCenter.php public_html/api/healthz.php public_html/hr/governance.php public_html/hr/_master_nav.php"

BACKED=0
rollback() {
  rc=$?
  if [ "$rc" -ne 0 ] && [ "$BACKED" -eq 1 ]; then
    echo "INSTALL FAIL -> rollback"
    for rel in $FILES; do
      if grep -Fxq "$rel" "$MISSING" 2>/dev/null; then
        rm -f "$ROOT/$rel"
      elif [ -f "$BACK/$rel" ]; then
        mkdir -p "$ROOT/$(dirname "$rel")"
        cp "$BACK/$rel" "$ROOT/$rel"
      fi
    done
    rm -f "$ROOT/private/jobs/jobs_config.php.p2tmp"
    echo "ROLLBACK OK: $BACK"
  fi
  exit "$rc"
}
trap rollback EXIT HUP INT TERM

echo "[1/12] Validate Core v3 baseline..."
for f in   private/core/bootstrap.php   private/core/Queue.php   private/core/BaseRepository.php   private/core/Schema.php   private/jobs/jobs_config.php   private/payroll/payroll_engine.php   private/ux/ActionCenter.php   public_html/hr/_master_nav.php
do
  test -f "$ROOT/$f" || { echo "MISSING BASELINE: $ROOT/$f" >&2; exit 1; }
done

echo "[2/12] Verify package integrity + syntax + static path safety..."
test -f "$PKG/README.txt"
test -f "$PKG/MANIFEST.sha256"
if command -v sha256sum >/dev/null 2>&1; then
  (cd "$PKG" && sha256sum -c MANIFEST.sha256)
fi
find "$PKG/private" "$PKG/public_html" -type f -name '*.php' -print | while IFS= read -r f; do "$PHP" -l "$f"; done
for rel in $RUNTIME_SCAN; do
  if grep -nE '/home/u[0-9]+' "$PKG/$rel" 2>/dev/null; then
    echo "Hardcoded hosting home path found in package runtime: $rel" >&2
    exit 1
  fi
done

echo "[3/12] Backup production targets..."
mkdir -p "$BACK"
: > "$MISSING"
for rel in $FILES; do
  if [ -f "$ROOT/$rel" ]; then
    mkdir -p "$BACK/$(dirname "$rel")"
    cp "$ROOT/$rel" "$BACK/$rel"
  else
    echo "$rel" >> "$MISSING"
  fi
done
BACKED=1

echo "[4/12] Install Governance core..."
mkdir -p "$ROOT/private/governance" "$ROOT/private/governance/audit" "$ROOT/private/governance/state" "$ROOT/private/governance/config_backups" "$ROOT/private/cron" "$ROOT/private/tools" "$ROOT/public_html/api" "$ROOT/public_html/hr/assets"
chmod 700 "$ROOT/private/governance" "$ROOT/private/governance/audit" "$ROOT/private/governance/state" "$ROOT/private/governance/config_backups" 2>/dev/null || true
cp "$PKG/private/core/AuditLog.php" "$ROOT/private/core/AuditLog.php"
for f in policy.php ConfigVault.php PayrollGovernance.php Health.php; do cp "$PKG/private/governance/$f" "$ROOT/private/governance/$f"; done
for f in governance_guard.php governance_config_backup.php; do cp "$PKG/private/cron/$f" "$ROOT/private/cron/$f"; done
for f in governance_backup.php governance_restore.php payroll_lock_month.php payroll_unlock_month.php payroll_mark_paid.php payroll_month_close.php p2_selftest.php; do cp "$PKG/private/tools/$f" "$ROOT/private/tools/$f"; done
cp "$PKG/private/ux/ActionCenter.php" "$ROOT/private/ux/ActionCenter.php"
cp "$PKG/public_html/api/healthz.php" "$ROOT/public_html/api/healthz.php"
cp "$PKG/public_html/hr/governance.php" "$ROOT/public_html/hr/governance.php"
cp "$PKG/public_html/hr/_master_nav.php" "$ROOT/public_html/hr/_master_nav.php"
cp "$PKG/public_html/hr/assets/p2.css" "$ROOT/public_html/hr/assets/p2.css"

echo "[5/12] Register governance jobs through existing Job Runner..."
MERLY_ROOT="$ROOT" "$PHP" "$PKG/private/tools/register_governance_jobs.php"
"$PHP" -l "$ROOT/private/jobs/jobs_config.php.p2tmp"
mv "$ROOT/private/jobs/jobs_config.php.p2tmp" "$ROOT/private/jobs/jobs_config.php"

echo "[6/12] Production syntax..."
for rel in $RUNTIME_SCAN; do "$PHP" -l "$ROOT/$rel"; done
"$PHP" -l "$ROOT/private/jobs/jobs_config.php"

echo "[7/12] Verify registered jobs are idempotent..."
MERLY_ROOT="$ROOT" "$PHP" "$PKG/private/tools/register_governance_jobs.php" >/dev/null
"$PHP" -l "$ROOT/private/jobs/jobs_config.php.p2tmp" >/dev/null
cmp -s "$ROOT/private/jobs/jobs_config.php" "$ROOT/private/jobs/jobs_config.php.p2tmp" || { echo "P2 JOB REGISTER FAIL: second registration changed config" >&2; exit 1; }
rm -f "$ROOT/private/jobs/jobs_config.php.p2tmp"

echo "[8/12] Create initial config backup..."
MERLY_ROOT="$ROOT" "$PHP" "$ROOT/private/tools/governance_backup.php" --actor=INSTALLER --reason="P2 initial snapshot"

echo "[9/12] Self-test installed governance runtime..."
MERLY_ROOT="$ROOT" "$PHP" "$ROOT/private/tools/p2_selftest.php"

echo "[10/12] Initial payroll governance scan (best effort)..."
if MERLY_ROOT="$ROOT" "$PHP" "$ROOT/private/cron/governance_guard.php"; then :; else echo "WARN: initial Lark scan failed; scheduled governance_guard will retry automatically."; fi

echo "[11/12] Health snapshot..."
MERLY_ROOT="$ROOT" "$PHP" -r 'require getenv("MERLY_ROOT")."/private/governance/Health.php"; $h=MerlyHealth::snapshot(); echo "HEALTH SCORE ".$h["score"]."/100 ".$h["status"].PHP_EOL;'

echo "[12/12] Success..."
echo "CORE V3 P2.0.2 INSTALL OK"
echo "- common hash-chained audit log enabled"
echo "- payroll lock/source version guard every 10 minutes"
echo "- daily config backup at 03:20 via existing Job Runner"
echo "- restore requires explicit CLI --commit and makes pre-restore backup"
echo "- public external uptime endpoint: /api/healthz.php"
echo "- admin governance UI: /hr/governance.php"
echo "- installed self-test: private/tools/p2_selftest.php"
echo "- P0/P1 architecture and single Hostinger cron unchanged"
echo "Backup: $BACK"
BACKED=0
trap - EXIT HUP INT TERM
echo "INSTALL VERIFIED OK"
