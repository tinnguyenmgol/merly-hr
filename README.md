# Merly HR

Kho quản lý release/deploy của hệ thống **Merly HR**.

## Baseline hiện tại

- **Production baseline:** `Core v3 P3.4.2`
- Roadmap: `P3.4.2 → System Audit → Hardening RC → Regression → Payroll Dry Run → v3.0 Stable`
- **Trạng thái audit 2026-09-23:** `NOT_READY_FOR_STABLE`

## System Audit 2026-09-23

Live audit:
- Critical: 1
- High: 6
- Medium: 11
- Low: 1
- Pass: 19

Các blocker chính trước Stable:
- Lark webhook verification phải fail-closed.
- Webhook không được ACK 200 khi enqueue nội bộ thất bại.
- Queue retry/finish phải chống mất job khi lỗi I/O.
- `private/config.php` phải siết permission.
- `Schema.php` không được fallback âm thầm sang production IDs.
- GitHub cần canonical production source tree để có thể tái tạo production.

## Source of truth

Repo này hiện chứa deploy helpers, release notes, audit notes và snapshot P2. **Canonical full production tree chưa được import**, vì vậy chưa được coi là source-of-truth hoàn chỉnh.

Trước khi import full production source:
- tạo sanitized production capture;
- loại config secret/runtime/log/queue payload;
- nên chuyển repository sang **PRIVATE** vì đây là source HR/payroll nội bộ.

## Quy tắc an toàn

- Không commit `.env`, token, credential hoặc secret production.
- Không hard-code `LARK_APP_SECRET`, tenant token hoặc password.
- Feature mới phải tích hợp vào Core/Job Runner/Queue/Lock hiện có, tránh tạo hệ song song.
- Không gắn nhãn `v3.0 Stable` trước khi: System Audit sạch blocker + regression + payroll dry run đạt.

> Repository này hiện đang PUBLIC. Không đưa canonical HR/payroll production source lên repo trước khi đổi visibility hoặc có quyết định rõ ràng về mức độ công khai.
