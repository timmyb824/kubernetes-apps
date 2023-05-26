# Helpful commands for working with Kubeapps

```bash
# retrieve the kubeapps service account token
kubectl get --namespace default secret kubeapps-operator-token -o go-template='{{.data.token | base64decode}}'
```
