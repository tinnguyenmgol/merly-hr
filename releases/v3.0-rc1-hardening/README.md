# Merly HR v3.0 RC1 Hardening

Built from the 2026-09-23 production capture.

Production capture SHA256:
`e77f983bcadeffa49290aeb14a94c54f1206fca31b415697c8505db26fadc159`

RC1 package SHA256:
`8b4546e5378feddc376670b3e5d5a111329f1779e2f798ae0fece7825790cfef`

## Scope

- Lark webhook fail-closed verification.
- Non-2xx webhook response when durable enqueue fails.
- Queue retry/done/dead destination-first durability.
- Per-key queue dedupe lock.
- Config permission hardening.
- Fail-closed Schema configuration via local schema config generated at install.
- Dynamic dashboard/jobs root paths.
- Job Runner honors retry_attempts and treats proc_open pressure as transient only for retry-enabled steps.
- Self Review per employee/month lock.
- Self Review Admin reopen becomes genuinely editable.
- Safe dead-letter summary tool.
- Updated sanitized source capture script v3.1.

No Payroll/KPI business formula is changed.

## Deploy

Upload:
`/home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr-v3.0-rc1-hardening.zip`

Then:

```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-v3.0-rc1-hardening-local.sh
```

After deploy, run the v3.1 hardening audit. The remaining expected High blocker is source-of-truth until the repository is private and canonical sanitized source is imported.
