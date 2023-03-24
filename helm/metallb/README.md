# Installation

<https://metallb.universe.tf/installation/>

## Manifest

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
```

## Helm

You can install MetallLB with Helm by using the Helm chart repository: https://metallb.github.io/metallb

```bash
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb
```

A values file may be specified on installation. This is recommended for providing configs in Helm values:

```bash
helm install metallb metallb/metallb -f values.yaml
```
