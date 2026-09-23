# Merly HR v3.1 Hardening Audit — 2026-09-23

Production root: `/home/u297334112/domains/lark.merly.cloud`

Status: **NOT_READY_FOR_STABLE**

## Summary
- Critical: 0
- High: 1
- Medium: 5
- Low: 0
- Pass: 25

## High blocker
- `SOURCE_OF_TRUTH_INCOMPLETE` — Git repo still lacks canonical sanitized production source tree; production cannot yet be recreated from Git alone.

## Medium items
- PHP 8.1.34 (<8.2 target)
- process spawn pressure remains in recent logs
- recent pipeline failures remain in log tail
- 8 dead-letter queue items require review
- legacy hardcoded production root references remain

## Hardening controls now passing
- config.php mode 0600
- schema.local.php mode 0600
- Lark webhook fail-closed verification
- non-2xx ACK on internal webhook failure
- queue retry/finish durability
- queue dedupe lock
- Job Runner retry override handling
- portable jobs/dashboard root
- Cron + Runner recent
- no stale processing queue items
- audit hash chain valid
- secure dashboard session flags + session regeneration
- Self Review reopen editability
- Self Review per-record lock
- Schema fail-closed without production defaults

## Next gate
1. review 8 dead-letter items;
2. move source repository to private or create a private canonical-source repository;
3. capture source again with v3.1 sanitizer and import canonical tree;
4. rerun audit;
5. proceed to regression;
6. run Payroll Dry Run against 08/2026 manual payroll.
