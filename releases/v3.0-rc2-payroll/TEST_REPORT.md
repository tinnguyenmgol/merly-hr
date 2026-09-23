# RC2 pre-deploy test report

PASS:
- PHP and shell syntax
- package manifest
- existing payroll regression suite
- monthly salary is not reduced by OT minutes
- hourly regular minutes are not reduced by OT minutes
- regular hourly wage is not silently reused as OT rate
- sanitized August 2026 detailed replay: 9/9 NET matched within 0.01 VND rounding tolerance
- second install idempotency
- forced post-install failure rollback

Installer is calculator-only and does not create/update/delete Lark business records.
