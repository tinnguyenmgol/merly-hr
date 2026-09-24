# Merly Lark API Efficiency v2.0.0

Permanent optimization after September 2026 Lark organization quota exhaustion.

## Main quota multipliers found
- Payroll governance ran every 10 minutes and read 4 Base tables.
- Core guardian checked every 30 minutes with fresh EMPLOYEES / PERFORMANCE / PAYROLL reads.
- KPI Realtime computed every 15 minutes with source-table reads forced fresh.
- Dashboard read Lark Base directly on page loads.
- Attendance ran hourly and updated employee rows even when values were unchanged.
- Sales KPI upsert updated existing rows even when fields were unchanged.

## v2 changes
- dashboard local-cache-first;
- shared cache between legacy/Core/dashboard reads;
- writes invalidate affected table cache;
- KPI source-table cache up to 12h while computation remains every 15m;
- Core guardian every 6h using cached inputs;
- Payroll governance twice/day + 6h cache;
- Attendance twice/day + skip unchanged writes;
- Employee Directory once/day;
- Sales KPI skip unchanged writes;
- local API ledger remains enabled.

No payroll, KPI, performance, responsibility, or attendance formulas change.

Package SHA256:
`575473698754f93b958cd3006f4b7c9b807ae7cf762e23c7a358d9a5e105697b`
