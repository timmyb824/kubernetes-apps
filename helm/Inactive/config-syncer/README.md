# Install

## New install

```bash
helm install config-syncer \
  oci://ghcr.io/appscode-charts/config-syncer \
  --version v0.15.2 \
  --namespace kubeops --create-namespace \
  --set-file license=license.txt \
  --wait --burst-limit=10000 --debug
  ```

## Redeploy

```bash
helm upgrade config-syncer \
  oci://ghcr.io/appscode-charts/config-syncer \
  --version v0.15.2 \
  --namespace kubeops \
  --set-file license=license.txt \
  --wait --burst-limit=10000
  ```

## Automatic Licenses

```bash
# one-time request to register email and get api token
$ curl -d "email=***" -X POST https://license-issuer.appscode.com/register
Check your email for token%
```

```bash
# update email, cluster, token
curl -X POST -H "Content-Type: application/json" \
  -d '{"name":"***","email":"***","product":"config-syncer","cluster":"***","tos":"true","token":"***"}' \
  https://license-issuer.appscode.com/issue-license
```
