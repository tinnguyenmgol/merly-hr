# Merly HR Core v3 P2.0.2

Verified deployment release for Hostinger layout where `private/` is a sibling of `public_html/`.

Fixes:
- honors `MERLY_ROOT` when deployed from `.deploy`;
- static hardcoded-path scan checks runtime source only, not backup/state data;
- installs `private/tools/p2_selftest.php` so post-deploy verification is real;
- validates package manifest and all PHP syntax before production writes;
- checks governance job registration is idempotent;
- keeps automatic rollback for modified production targets.

Validation performed before publishing:
- full install on a synthetic production tree: PASS;
- installed self-test: PASS, 90/100 healthy in the synthetic environment;
- duplicate job registration test: PASS;
- forced failure after jobs config commit: rollback PASS;
- PHP lint and shell syntax: PASS.

Deploy from the repository with:

```sh
cd /home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr
git pull
sh deploy/deploy-p2.0.2.sh
```
