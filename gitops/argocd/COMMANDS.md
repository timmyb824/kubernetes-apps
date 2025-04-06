# Commands

## Install ArgoCD

```bash
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n argocd
```

## Rolling update all deployments

```bash
kubectl rollout restart deployment -n argocd
```

## If admin password doesn't work then fetch temp password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Set user password

```bash
argocd account update-password \
  --account <name> \
  --current-password <current-user-password> \
  --new-password <new-user-password>
```
