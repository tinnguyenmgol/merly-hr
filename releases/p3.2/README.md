# Core v3 P3.2

P3.2 completes the operational information missing from KPI Realtime before System Audit.

## Added

- Incident detail: first/last seen, occurrence count, affected job/step, recommended action, latest log excerpt and Lark Admin delivery status.
- Recovery lifecycle: `active -> recovered_monitoring -> resolved`, with up to 20 recently resolved incidents.
- Recovery detection for transient Hostinger process-spawn pressure and DNS/Lark API timeouts when the same step later succeeds.
- KPI amount detail: actual sales, monthly target, expected-to-date amount, amount gap, remaining target, and average required per remaining calendar day.
- Per-metric Lark alert status in employee detail.
- Numeric department codes get a clear UI label while preserving the underlying group code.

## Safety

- No new Hostinger cron.
- No automatic Responsibility point deduction.
- No Performance or Payroll calculation changes.
- Deploy refreshes KPI/Health state with notifications disabled; scheduled jobs continue normally afterward.
- Installer backs up code plus KPI/Health state and rolls both back on failure.

## Package

Place:
`/home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr-core-v3-p3.2.zip`

SHA256:
`3dfd9c3787bb08f2cdb463d9c1ff2e10dc437c5909c3b18476e514eaca2702c0`

Deploy:

```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-p3.2-local.sh
```

Next gate: **System Audit -> regression -> payroll dry-run -> v3.0 Stable**.
