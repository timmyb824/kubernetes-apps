# Install

```bash
helm install config-syncer \
  oci://ghcr.io/appscode-charts/config-syncer \
  --version v0.15.2 \
  --namespace kubeops --create-namespace \
  --set-file license=license.txt \
  --wait --burst-limit=10000 --debug
  ```
