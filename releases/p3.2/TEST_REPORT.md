# P3.2 pre-deploy test report

Tested before packaging on 2026-09-22.

- PHP syntax for all package PHP files: PASS
- install.sh syntax: PASS
- P3.2 offline self-test: PASS
- KPI amount math: PASS
- Health parser against supplied production error log: PASS
  - PROCESS_SPAWN_PRESSURE = 7 occurrences, active from available evidence
  - EXTERNAL_API_TIMEOUT = 1 occurrence, recovered by retry at 11:10:44
  - no false JOB_RUNNER_FATAL
- Recovery-notification transition after deploy --no-send: PASS
- Pending recovery notification after deploy-time resolution: PASS
- KPI Realtime HTML render smoke test: PASS
- Installer integration on synthetic P3.1 production tree: PASS
- Forced mid-install failure and rollback of code + dashboard state: PASS

Live Lark Base/API calls were intentionally not executed in the local pre-deploy suite. Production install refreshes KPI state with retry and suppresses deployment-time Lark notification spam.
