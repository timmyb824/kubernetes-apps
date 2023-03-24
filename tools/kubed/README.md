# Summary

Kubed can keep ConfigMaps and Secrets synchronized across Namespaces. I use this to copy my TLS certificates across all Namespaces so that they are always accessible.

Refer to [kubed](https://appscode.com/products/kubed/v0.12.0/concepts/what-is-kubed/overview/) for more information.

## Installation

```shell
# add repo
helm repo add appscode https://charts.appscode.com/stable/
helm repo update
helm search repo appscode/kubed --version v0.12.0

# install kubed
helm --kubeconfig config install kubed appscode/kubed --version v0.12.0 --namespace kube-system

# confirm its running
kubectl --kubeconfig ./config get deployment --namespace kube-system -l "app.kubernetes.io/name=kubed,app.kubernetes.io/instance=kubed"

# To annotate a secret and replicate it across namespaces
kubectl --kubeconfig ./config annotate secret letsencrypt-staging kubed.appscode.com/sync="" -n cert-manager
```
