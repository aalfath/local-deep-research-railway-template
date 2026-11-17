# Changelog

## 2026-11-17: Deploy on Railway button

- README: added the Deploy on Railway button for the published template `local-deep-researc-1`. No change to the services or images.

## 2026-11-17: Local Deep Research 2.0.1

First release of the template.

- Local Deep Research `2.0.1` (`localdeepresearch/local-deep-research@sha256:867e4ebf8baff9b5a759d2ae154359fe0ecb19b5e8231409feea4e781d5733ae`), with a volume at `/data` and health check `/api/v1/health`.
- First account created on first boot from `ADMIN_USERNAME` and `ADMIN_PASSWORD`. Open sign-up off by default.
- Private SearXNG `2026.11.15-2d500cb6b` (`sha256:932f69dca010db9880bddebb2171f05d8e1a25d04a59149ff65409993d680024`), reachable only over Railway's private network.
