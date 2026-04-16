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

## Update ArgoCD

Get latest version from https://github.com/argoproj/argo-cd/releases:

```bash
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/<version>/manifests/install.yaml
```

Last updated: 2026-04-16
Comment: No additional changes were needed. Custom resources were already in place.
