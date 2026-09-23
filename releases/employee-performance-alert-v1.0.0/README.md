# Merly Employee Performance Alert v1.0.0

Adds proactive Lark reminders on top of the existing KPI Realtime monitor.

## Existing behavior retained
- KPI Realtime runs every 15 minutes.
- Direct employee alerts already use the durable Core queue.
- Same-severity cooldown remains 24 hours.
- Severity escalation remains immediate.
- Recovery is sent once.
- No automatic Responsibility point deduction, Performance edit, or Payroll edit.

## New behavior
- Employee alert text includes a concrete next action.
- Critical alerts escalate to same-group Manager/Leader and all Admins.
- Daily 20:30 Manager/Admin digest summarizes active KPI issues only when issues exist.
- Self Review reminders:
  - day 28: review window opened;
  - day 2 next month: two-day reminder;
  - day 3: deadline reminder;
  - day 3 also sends pending summary to relevant Manager/Admin.
- No new Hostinger cron; the existing Job Runner schedules both jobs.

## Recipient rules
- Employee KPI alert -> employee Lark UID.
- Critical -> employee + same-group Manager/Leader + Admin.
- Daily digest -> Manager own group; Admin all groups.
- Self Review reminder -> pending employee; deadline summary -> Manager/Admin.

## Package
Upload to:
`/home/u297334112/domains/lark.merly.cloud/.deploy/merly-employee-performance-alert-v1.0.0.zip`

SHA256:
`fef423377242e325d0f7699407252467a58ea026dbd140eb8a60d09833675208`

Deploy:
```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-employee-performance-alert-v1-local.sh
```
