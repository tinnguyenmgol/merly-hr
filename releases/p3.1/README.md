# Core v3 P3.1

Final P3 correction before System Audit.

Changes:
- Sales KPI is no longer inferred from a zero-value formula row alone.
- CR/UPT alerts are evaluated only when the employee actually has Sales KPI.
- Employees without Sales KPI no longer show period-progress comparison.
- Numeric department ids are labeled `PHÒNG BAN <id>` instead of appearing as unexplained bare numbers.
- Master navigation CSS/JS is installed globally; fixes the unstyled header/mobile menu seen on KPI Realtime.
- Active infrastructure warning details are shown directly under System Health status.
- P3 self-test covers the false-sales-KPI case.

Validated locally:
- PHP syntax: PASS
- shell syntax: PASS
- JavaScript syntax: PASS
- P3 self-test: PASS

Expected local package:
- `/home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr-core-v3-p3.1.zip`
- SHA256: `0809426ff5070dba9a5f0cde3a6435b8e606111dfafa97f743aab087e80d9445`

Deploy:
```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-p3.1-local.sh
```

After P3.1 is clean, proceed to System Audit -> regression -> payroll dry-run -> v3.0 Stable.
