# Core v3 P3 deployment

P3 integrates KPI Realtime with the existing Core queue/Job Runner/Lark alert stack.

The release ZIP is intentionally distributed separately because binary uploads through the current GitHub connector were not byte-safe. Do not store a corrupted binary in the repository.

Expected ZIP:
- filename: `merly-hr-core-v3-p3.zip`
- SHA256: `afd83e67480dfa7150eb2f153d391dfa82af9ab9d34d10c73a60527d9df33ae2`
- place at: `/home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr-core-v3-p3.zip`

Deploy:
```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-p3-local.sh
```

Health behavior in P3:
- stale/missing Cron or Runner heartbeat: critical;
- unresolved PIPELINE FAIL: critical;
- proc_open/fork pressure while Runner remains alive: warning `PROCESS_SPAWN_PRESSURE`;
- DNS/Lark resolve timeout: warning `EXTERNAL_API_TIMEOUT`;
- stale false `JOB_RUNNER_FATAL` auto-resolves when the runner is healthy.

KPI behavior:
- watch every 15 minutes using existing Job Runner;
- Sales progress, CR, UPT, attendance late, Responsibility score;
- same-severity alert cooldown 24h; escalation immediate; recovery once;
- CR below threshold for 3 days can create review-only Responsibility event with 0 points;
- other critical KPI for 48h can create review-only event with 0 points;
- no automatic Responsibility deduction, Performance edit, or Payroll edit.

Next gate: System Audit -> regression/payroll dry-run -> v3.0 Stable.
