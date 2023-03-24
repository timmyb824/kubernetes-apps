# Installation

```bash
helm repo add odigos https://keyval-dev.github.io/odigos-charts/

helm repo update

helm install my-odigos odigos/odigos --namespace odigos-system --create-namespace

kubectl port-forward svc/odigos-ui 3000:3000 -n odigos-system
```
**Beware:** this crashed my k3s cluster
