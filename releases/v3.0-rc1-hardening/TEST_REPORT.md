# RC1 Hardening test report

PASS:
- modified PHP/shell/JavaScript syntax
- package manifest
- webhook challenge 200
- missing token 403
- wrong token 403
- valid token durable enqueue 200
- forced queue storage failure 503
- 20-way concurrent dedupe => 1 queued / 19 deduped
- retry and done queue transitions
- Schema fail-closed without config
- Schema local resolution
- Job Runner retry_attempts=2 => exactly 2 attempts
- Self Review reopen editability rules
- synthetic P3.4.2 install
- second install idempotency
- forced post-install failure rollback
- replacement source capture v3.1 excludes local config + runtime Haravan token/session text files

Important source-capture finding: the earlier 2026-09-23 archive unexpectedly contained Haravan runtime token/session text files. Their values were not committed or printed. Rotate/refresh them and delete the old archive after use.
