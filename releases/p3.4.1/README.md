# Core v3 P3.4.1

Dashboard-route activation correction.

## Root cause
Core P1 preserved the working dashboard at `/hr/dashboard.php`. P3.4 correctly patched `app.js`, but only cache-busted/injected Self Review assets in `/hr/index.php`. The real dashboard route therefore kept loading the old cached frontend. This explains why **both** Monthly Self Review and KPI Settings links were still missing.

## Fix
- patch `/hr/dashboard.php` and `/hr/index.php`;
- force `app.js?v=1.2.4-p341`;
- inject exactly one Self Review CSS/JS pair;
- verify P3.4 frontend markers before changing production.

## Package
Place:
`/home/u297334112/domains/lark.merly.cloud/.deploy/merly-hr-core-v3-p3.4.1.zip`

SHA256:
`8fbb6c6be5bdff4ff1454f605af5754e5f287f4b77e215857627941170c85ba0`
