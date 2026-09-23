# Merly Lark API Budget Guard v1.0.1

Hotfix after v1.0.0 rolled back on Hostinger.

## Root cause
- The v1.0.0 self-test called PHP `exec()` even though the installer had already run `php -l` checks.
- Hostinger process-spawn pressure/restrictions can make that self-test fail.
- v1.0.0 also attempted mode `0600` on a directory; v1.0.1 keeps the state directory at `0700` and state files at `0600`.

## Emergency behavior retained
- KPI Realtime max one real run / 10h
- Attendance max one real run / 3h
- Employee directory max one real run / 24h
- auto expiry 2026-10-01 00:05 Asia/Ho_Chi_Minh
- manual `--force` bypass
- legacy tenant-token cache + local API-family counters

No business formula changes.

Package SHA256:
`6279019ce79ac40a9a50e7317195d1555e873735d590a705c31ba36dd51b414b`
