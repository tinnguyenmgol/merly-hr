# Merly HR v3.0 RC2 — Payroll correctness

RC2 fixes the payroll discrepancy exposed by the August 2026 final-gate replay.

## Root cause
- `ATTENDANCE_MONTHLY.Tổng phút làm thực tế` represents regular in-shift minutes.
- approved OT is stored separately.
- PAYROLL-v1.1 subtracted OT from regular minutes a second time, reducing salary whenever OT existed.
- PAYROLL-v1.1 could also silently reuse regular hourly wage as OT rate.

## Fix
- regular pay uses actual regular minutes directly;
- OT is added separately;
- OT rate priority: manual payroll OT rate -> employee `Đơn giá OT` -> configured default with review guard;
- regular `Đơn giá giờ` is no longer silently used as OT rate;
- formula version becomes `PAYROLL-v1.2`.

## Validation
- sanitized August detailed replay: 9/9 rows matched historical NET within rounding tolerance;
- existing payroll self-test updated for the corrected semantics;
- second install idempotent;
- forced failure rollback passed.

Six August historical payroll-only rows lacked detailed attendance/performance inputs and are not counted as formula-replay coverage.

Package SHA256:
`a4caf7fc58e9892c9554fcc7002a192bb8fa00fc4c8e29c4cda5e5c9fd21c98d`
