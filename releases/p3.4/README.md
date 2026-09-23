# Core v3 P3.4

Frontend integration correction before System Audit.

## Fixes
- Monthly Self Review always has a visible placeholder in employee detail and My Profile.
- Dynamic loader for Self Review assets; not dependent only on the static index tag.
- Before day 28, the 1-5 scorecard is visible read-only. Input opens day 28 -> day 03 next month.
- Admin KPI cards restore direct settings links for Personal KPI, Group KPI, Upsell and Top bill.
- Settings links deep-link and highlight the exact employee/group/rule section.
- Dashboard respects `?view=settings`.
- No Payroll / Performance / Responsibility formula change.

## Package
Place:
`/home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr-core-v3-p3.4.zip`

SHA256:
`e38c87401375ddc1fddef247902bb4f777d97ead3384ee243e649730d4029f74`

Deploy:
```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-p3.4-local.sh
```
