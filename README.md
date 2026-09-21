# Merly HR

Kho source chính của hệ thống **Merly HR**.

## Baseline hiện tại

- **Current baseline:** `merly-hr-core-v3-p2`
- Kiến trúc đang đi theo chuỗi: `v3-p0 → v3-p1 → v3-p1.0.1 → v3-p2 → v3-p3 → System Audit → v3.0 Stable`
- **KPI Realtime Alert v1.0.0** hiện chỉ được lưu như **prototype** để merge vào Core v3 P3; **không deploy standalone**.

## Snapshot 2026-09-21

File backup source: `snapshots/merly-hr-source-snapshot-2026-09-21.zip`

Snapshot này chứa 24 package gần nhất liên quan Core HR, Lark, Attendance, KPI, Dashboard, Responsibility, Payroll, Onboarding, Reliability và prototype KPI Realtime.

SHA256:

`4fc07e609b95738a4d8c8c97a53e0719e3f440394cc0dc9781e5e343d7b6adb4`

## Quy tắc an toàn

- Không commit `.env`, token, credential hoặc secret production.
- Không hard-code `LARK_APP_SECRET`, tenant token hoặc password.
- Feature mới phải tích hợp vào Core/Job Runner/Queue/Lock hiện có, tránh tạo hệ song song.
- Trước khi gắn nhãn `v3.0 Stable`: chạy System Audit + regression + payroll dry run.

> Repository này hiện đang PUBLIC. Chỉ source đã qua secret scan mới được đưa lên đây.
