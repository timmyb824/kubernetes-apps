# Commands

## Install ArgoCD

```bash
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n argocd
```

## Rolling update all deployments

```bash
kubectl rollout restart deployment -n argocd
```

## Set user password

```bash
argocd account update-password \
  --account <name> \
  --current-password <current-user-password> \
  --new-password <new-user-password>
```
