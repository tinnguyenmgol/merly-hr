# Merly Lark API Budget Guard v1.0.0

Emergency optimization after the organization reached 9,865 / 10,000 Lark API calls in September 2026.

## Immediate savings
- KPI Realtime is temporarily throttled to at most one real run every 10 hours.
- Attendance sync is temporarily throttled to one real run every 3 hours.
- Employee directory sync is temporarily throttled to one real run every 24 hours.
- Emergency throttling automatically expires at 2026-10-01 00:05 Asia/Ho_Chi_Minh.
- Manual `--force` bypass remains available.

## API reduction
- Adds shared file cache for the legacy `lark_token()` path.
- Existing Core tenant-token cache remains intact.
- Counts Merly HR Lark calls locally by API family for later optimization.

## Safety
No Payroll, Performance, KPI, Responsibility, or Attendance formula changes.

Package SHA256:
`5e50269aedf002160088f39749d847f44f4dd9b4f2d05354683a77a7d1967a36`
