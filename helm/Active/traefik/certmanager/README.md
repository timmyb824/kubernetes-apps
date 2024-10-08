# Install

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
# apply the CRDs
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.0/cert-manager.crds.yaml

# install with helm
helm install cert-manager jetstack/cert-manager --namespace cert-manager --values=values.yaml --version v1.9.1

# upgrade to a specific version
helm upgrade cert-manager jetstack/cert-manager --namespace cert-manager --values=values.yaml --version v1.16.0

# deploy the issuer and certificate
kubectl apply -f issuers/secret-cf-token.yaml
kubectl apply -f issuers/letsencrypt-staging.yaml
kubectl apply -f certificates/staging/local-timmybtech-com.yaml
kubectl apply -f issuers/letsencrypt-production.yaml
kubectl apply -f certificates/staging/local-timmybtech-com.yaml
```

## Backup and restore

```bash
kubectl get --all-namespaces -oyaml issuer,clusterissuer,cert > backup.yaml

kubectl apply -f <(awk '!/^ *(resourceVersion|uid): [^ ]+$/' backup.yaml)
```
