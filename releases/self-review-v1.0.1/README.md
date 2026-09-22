# Merly Monthly Self Review v1.0.1

Regression-safe update after the first production attempt created the Lark table successfully but failed while patching dashboard assets.

## Fixes
- removes PHP `exec()` dependency from dashboard patching;
- validates patched `index.php` from the shell instead;
- supports compact/full dashboard HTML defensively;
- keeps CSS/JS asset injection idempotent;
- moves remote Lark table setup to the final install step;
- reuses the already-created `MONTHLY_SELF_REVIEW` table.

## Package
Upload to:
`/home/u297334112/domains/lark.merly.cloud/.deploy/merly-monthly-self-review-v1.0.1.zip`

SHA256:
`c1f457ef64f42a8be5df658a7036ea178e9f319a1d0d50eb69fb0994a2f78315`

Deploy:
```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-self-review-v1.0.1-local.sh
```
