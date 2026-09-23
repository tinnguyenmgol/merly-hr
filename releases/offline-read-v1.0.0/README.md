# Merly HR Offline Read v1.0.0

Emergency fallback for Lark quota exhaustion after login was restored but dashboard data still failed.

## Behavior
- live/fresh cache remains first choice;
- on Lark quota exceeded, Core reads fall back to stale local table cache;
- direct dashboard reads bridge to the same stale Core cache;
- if a table has no stale cache, read-only UI receives an empty dataset rather than crashing;
- home page shows a clear cached/offline banner;
- successful live reads automatically clear offline state after Lark recovers.

## Safety
- read fallback only;
- no write is faked as successful;
- no formula changes.

Package SHA256:
`dc7ba8f3bc87f65c2cd3e065bcd3bb21e8177f470a4666679455aa8ce9c898d1`
