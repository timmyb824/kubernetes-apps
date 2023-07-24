# Commands

## Install ArgoCD

```bash
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## Rolling update all deployments

```bash
kubectl rollout restart deployment -n argocd
```
