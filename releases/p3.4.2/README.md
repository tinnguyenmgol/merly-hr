# Core v3 P3.4.2

Corrects the P3.4.1 regression self-test.

Root cause: Core P1 uses `/hr/index.php` as the workspace home page and `/hr/dashboard.php` as the preserved dashboard. P3.4.1 correctly patched the real dashboard, but its self-test incorrectly required `index.php` to contain the dashboard `app.js` cache-bust too.

P3.4.2:
- patches only `/hr/dashboard.php`;
- validates Self Review CSS/JS exactly once on the real dashboard;
- cache-busts `app.js` / `app.css` on the real dashboard;
- leaves the Core P1 workspace home untouched.

SHA256:
`4a393e9a2fb1b3e5240931260286045053e2a5dceafec8ab30b8667b060eeeec`
