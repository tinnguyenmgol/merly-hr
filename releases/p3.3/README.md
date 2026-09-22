# Core v3 P3.3

Usability/data-membership correction before System Audit.

## Fixes
- Monthly Self Review is visible immediately in the employee drawer and My Profile, including before day 28 as read-only preview.
- Direct dashboard mount plus fallback observer/polling prevents the panel from disappearing after drawer rerenders.
- Group KPI is propagated to every recognized sales-group member (ONLINE / 561 / 876), even without a Haravan User ID.
- No-Haravan employees keep existing manual personal sales; those values are not double-counted into group totals.
- Per-employee personal KPI target continues to use the monthly target or the employee field `KPI cá nhân mặc định`.
- The detail drawer shows group KPI even before an individual target is assigned.

## Package
Upload to:
`/home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr-core-v3-p3.3.zip`

SHA256:
`78d5a2d572712ec18cad147965b6a13545248b35084d213727b810a2010b9832`

Deploy:
```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-p3.3-local.sh
```

After this correction is clean, continue to System Audit -> regression -> payroll dry-run -> v3.0 Stable.
