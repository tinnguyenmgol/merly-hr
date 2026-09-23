# Merly HR Emergency Local Login v1.0.0

Emergency fallback for Lark Base quota exhaustion.

- keeps Lark OAuth identity verification;
- live EMPLOYEES remains the primary source;
- only on quota-exceeded does login fall back to a local employee snapshot;
- if no prior snapshot exists, exact unique OAuth display-name match against local KPI Realtime state is allowed with least privilege;
- ambiguous/no-match identities are denied;
- EMPLOYEES and current SALES_KPI can be synthesized from local state so the dashboard can open instead of hard-failing;
- successful live EMPLOYEES reads refresh the local snapshot automatically after Lark quota recovers;
- no anonymous bypass and no payroll/KPI formula change.

Package SHA256:
`24f4f1f44c45d28fc02db6b7a97c727954f54ec33b4180b99c78792cfe81e394`
