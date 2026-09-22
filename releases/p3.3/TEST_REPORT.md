# P3.3 pre-deploy test report

Tested before packaging on 2026-09-22.

- package manifest: PASS
- PHP / shell / JavaScript syntax: PASS
- dashboard patch on dashboard-selfservice v1.2.2: PASS
- self-review tags inserted when missing: PASS
- direct drawer mount + fallback observer/poll: PASS
- Self Review criteria/window regression: PASS
- second-install idempotency: PASS
- sales membership unit test: PASS
- mocked end-to-end SALES_KPI sync: PASS
  - all sales-group members receive SALES_KPI rows
  - group KPI copied to no-Haravan members
  - manual personal sales preserved
  - group total not double-counted
  - personal KPI defaults seeded
- forced mid-install failure: PASS
- rollback of dashboard/self-review/sales files: PASS

Production Haravan/Lark refresh remains best-effort; the existing Job Runner retries external failures.
