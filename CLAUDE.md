# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

GitOps-managed Kubernetes applications for a home k3s cluster (3 control plane + 3 worker nodes). Applications are deployed via ArgoCD.

## Directory Layout

- `gitops/app-configs/` — ArgoCD `Application` manifests (one per app)
- `gitops/manifests/<app>/` — Raw Kubernetes resources for each app (supplementary to Helm charts)
- `gitops/argocd/` — ArgoCD bootstrap resources and configuration
- `non-gitops/traefik/` — Traefik managed outside GitOps due to complexity
- `gitops-archive/` — Previously deployed apps kept for reference
- `tools/` — Documentation for cluster management tools (kubeshark, helm dashboard, etc.)

## Deployment Architecture

Most apps use a **two-source ArgoCD Application** pattern:
1. **External Helm chart** — references an upstream chart registry with inline `values:`
2. **Local manifest path** — references `gitops/manifests/<app>/` in this repo for supplementary resources (IngressRoutes, PVCs, Secrets, RBAC)

Some simpler apps (like Prometheus) use only a local manifest source with no Helm chart.

## Common Manifest Patterns

**Ingress**: Traefik `IngressRoute` (not standard `Ingress`):
```yaml
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
spec:
  entryPoints: [websecure]
  routes:
    - match: Host(`app.local.timmybtech.com`)
  tls:
    secretName: local-timmybtech-com-tls  # or timmybtech-com-tls for public
```

**Secrets via AVP**: Secrets reference HashiCorp Vault paths using ArgoCD Vault Plugin annotations:
```yaml
metadata:
  annotations:
    avp.kubernetes.io/path: "secret/data/<path>"
stringData:
  KEY: <path:secret/data/<path>#FIELD>
```

**Storage**: NFS-backed PVCs using `storageClassName: nfs-csi-synologynas`

**Node targeting**: `nodeSelector: kubernetes.io/hostname: <node>` used to pin workloads to specific nodes

**ArgoCD sync policy standard**:
```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: false
  syncOptions:
    - CreateNamespace=true
```

## Secret Management

- **SOPS + AGE** for encrypting secrets committed to the repo
- **ArgoCD Vault Plugin (AVP)** for injecting secrets from Vault at deploy time
- Pre-commit hooks enforce that files matching patterns in `.sops-required-files` are encrypted before commit

## Pre-commit Hooks

Run automatically on commit:
- `check-yaml` — YAML validation
- `ripsecrets` + `trufflehog` — secret scanning
- `sops-encryption-check` — ensures sensitive files are SOPS-encrypted

Install hooks: `pre-commit install`

## Dependency Updates

Renovate bot is configured to auto-update Helm chart versions and image tags in `gitops/**` and `non-gitops/**`.

## Adding a New Application

1. Create `gitops/manifests/<app>/` with supplementary resources
2. Create `gitops/app-configs/<app>.yaml` as an ArgoCD `Application`
3. Reference the Helm chart (if applicable) as the first source and the local manifest path as the second source
4. Use `avp.kubernetes.io/path` annotations on any `Secret` resources

## Domain Naming Convention

- Internal services: `<app>.local.timmybtech.com` (uses `local-timmybtech-com-tls`)
- Public services: `<app>.timmybtech.com` (uses `timmybtech-com-tls`)
