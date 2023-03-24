# Summary

This will create prometheus, alertmanager, and grafana. Refer to [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) for more details.

## Installation

Add repo

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Create credentials for grafana

```shell
# create files
echo -n 'username' > ./prometheus-helm/admin-user
echo -n 'password123' > ./prometheus-helm/admin-password

# create secret from files
kubectl create secret generic grafana-admin-credentials --from-file=./secrets/admin-user --from-file=./secrets/admin-password -n monitoring
```

Deploy prometheus, alertmanager, grafana

```shell
helm install -n monitoring monitoring-stack prometheus-community/kube-prometheus-stack -f prometheus-helm/values.yaml
```

## Uninstallation

This removes all the Kubernetes components associated with the chart and deletes the release:

`helm uninstall [RELEASE_NAME]`

CRDs created by this chart are not removed by default and should be manually cleaned up:

```shell

kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com
```

Finally, delete the ingressroute and secret.
