# Merly HR v3 System Audit — 2026-09-23

Production root: `/home/u297334112/domains/lark.merly.cloud`

Status: **NOT_READY_FOR_STABLE**

## Summary

- Critical: 1
- High: 6
- Medium: 11
- Low: 1
- Pass: 19

## Critical

1. `WEBHOOK_VERIFY_FAIL_OPEN`
   - Missing Lark verification token can bypass verification under the current condition.

## High

1. `CONFIG_PERMS` — `private/config.php` mode is 0644.
2. `WEBHOOK_FAIL_ACK` — internal webhook failure can still return HTTP 200.
3. `QUEUE_RETRY_LOSS` — processing file is removed before pending retry is safely committed.
4. `QUEUE_FINISH_LOSS` — processing file is removed before done/dead copy is safely committed.
5. `SCHEMA_PROD_DEFAULTS` — Schema fallback contains direct production Base/table IDs.
6. `SOURCE_OF_TRUTH_INCOMPLETE` — Git cannot yet recreate production.

## Medium requiring hardening/regression

- PHP 8.1 rather than >=8.2.
- queue dedupe race.
- Job Runner retry settings do not fully honor per-step config.
- Hostinger process-spawn pressure.
- pipeline failures in recent logs.
- 8 dead-letter queue items require review.
- dashboard session id regeneration not detected.
- Self Review reopen logic does not restore employee editability.
- Self Review uniqueness is application-level only.
- legacy hardcoded production roots remain.
- README baseline was stale (corrected in this audit commit).

## Passing controls

- Core runtime present.
- 417 PHP files parse successfully.
- curl/json/mbstring available.
- no obvious public secret exposure found.
- Cron and Runner heartbeat recent.
- required Core v3 jobs enabled.
- no stale processing queue item >30 minutes.
- config backup recent; restore tool exists.
- audit hash chain valid (481 rows).
- session cookie has HttpOnly + Secure + SameSite.
- queue currently: pending 0, processing 0, done 34, dead 8.

## Stable gate

Do not tag v3.0 Stable until:
1. hardening release fixes Critical/High and selected correctness Medium items;
2. regression suite passes;
3. dead-letter items are reviewed;
4. Payroll Dry Run (target: 08/2026) is reconciled against the manual Excel payroll;
5. canonical sanitized source is captured and versioned in a private source repository or equivalent controlled source of truth.
