# Source capture security notice

The old source-capture script selected `*.txt` and therefore included runtime files that should have been excluded:
- `private/haravan_report_token.txt`
- `private/haravan_admin_session.txt`
- `private/haravan_session_sync_token.txt`
- local `private/dashboard/config.php` was also included.

No secret values are reproduced here and none should be committed to Git.

RC1 includes capture script v3.1, which excludes local config, schema.local, runtime credential/session text data, queue payloads, logs, backups and runtime state.

Operational follow-up:
1. rotate/refresh Haravan runtime credentials;
2. regenerate the session-sync token;
3. delete the old source archive from `.deploy`;
4. do not upload that old archive to GitHub.
