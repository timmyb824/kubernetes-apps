# Installaltion and Upgrading

```bash
# Add or update the repo
helm repo add jetstack https://charts.jetstack.io
helm repo update
# OR
helm repo add jetstack https://charts.jetstack.io --force-update

# Apply the CRDs
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.0/cert-manager.crds.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.2/cert-manager.crds.yaml

# New install with helm
helm install cert-manager jetstack/cert-manager --namespace cert-manager --values=values.yaml --version v1.9.1

# Upgrades
helm upgrade cert-manager jetstack/cert-manager --namespace cert-manager --values=values.local.yaml --version v1.16.0 # last run November 4, 2024
helm upgrade cert-manager jetstack/cert-manager --namespace cert-manager --values=values.local.yaml --version v1.16.2 # last run Jan 5, 2025
helm upgrade cert-manager jetstack/cert-manager --namespace cert-manager --values=values.local.yaml --version v1.17.1 # last run Mar 30, 2025

# Deploying the cloudflare secret, issuers, and certificates
kubectl apply -f issuers/secret-cf-token.yaml
kubectl apply -f issuers/letsencrypt-staging.yaml
kubectl apply -f certificates/staging/local-timmybtech-com.yaml
kubectl apply -f issuers/letsencrypt-production.yaml
kubectl apply -f certificates/staging/local-timmybtech-com.yaml
```

## Backup and restore

```bash
kubectl get --all-namespaces -o yaml issuer,clusterissuer,cert > backup.yaml

kubectl apply -f <(awk '!/^ *(resourceVersion|uid): [^ ]+$/' backup.yaml)
```
