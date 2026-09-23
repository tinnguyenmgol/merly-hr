# Employee Performance Alert v1.0.0 - test report

PASS:
- PHP syntax for all package files.
- shell installer syntax.
- KPI Realtime patch applies once and is idempotent.
- second install succeeds without duplicate patching.
- role normalization: Admin / Manager / Leader / Employee.
- employee action-hint generation.
- critical escalation message generation.
- Manager/Admin daily digest generation.
- daily digest Job Runner registration at 20:30.
- Self Review reminder Job Runner registration at 10:30.
- forced patch failure rollback restores prior KPI/jobs files and removes newly-added files.
- package ZIP integrity.
- manifest verification.

Safety:
- no Payroll formula change;
- no Performance formula change;
- no Attendance formula change;
- no KPI formula change;
- no Responsibility score formula change;
- installer does not intentionally send live Lark notifications; scheduled jobs handle delivery after deploy.
