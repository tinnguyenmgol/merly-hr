# Merly Monthly Self Review v1.0.0

Self-review module shown directly inside the employee profile drawer / My profile page.

## Operating window
- Opens automatically on the 28th of the reviewed month.
- Remains open through the 3rd of the next month.
- Employee can save draft, then submit.
- Manager/Admin can review after employee submission.
- Admin can lock or reopen a review.

## Criteria profiles
- ONLINE: attendance, responsibility, teamwork, customer service, follow-up/CRM, initiative.
- POS: attendance, responsibility, teamwork, cleanliness/display, customer service, upsell.
- WAREHOUSE: attendance, responsibility, inventory/order accuracy, teamwork, cleanliness/organization, initiative.
- MANUFACTURE: attendance, responsibility, quality, teamwork, cleanliness, initiative.

System KPI / CR / UPT / lateness remain objective data shown elsewhere in Merly HR. Self-review does **not** automatically change Payroll, Performance or Responsibility points.

## Lark Base
Creates a separate table:
`MONTHLY_SELF_REVIEW`

One record per employee / month using key:
`YYYY-MM|MLxxxx`

## Package
Place:
`/home/u297334112/domains/lark.merly.cloud/.deploy/merly-monthly-self-review-v1.0.0.zip`

SHA256:
`350b5031c74a0044d08a4455ff8d68200bc01de6edd7fd7a0d95233835c5a5cc`

Deploy:
```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-self-review-v1.0.0-local.sh
```

The installer patches the existing dashboard index idempotently; it does not replace the main dashboard app.
