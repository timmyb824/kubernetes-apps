# Zabbix Helm Chart

# Introduction

This Helm chart installs Zabbix in a Kubernetes cluster.

# Prerequisites

- Kubernetes cluster 1.18+
- Helm 3.0+
- Zabbix server 6.0+
- kube-state-metrics 2.13.2+

*Note*

kube-state-metrics (Zabbix helm chart dependency) with Openshift installation requires one modification on Replica Set level:

```bash
      securityContext:
        runAsUser: 65534
        runAsGroup: 65534
        fsGroup: 65534
```
This block must be removed or changed.

## Zabbix Agent

**Zabbix agent** is deployed on a monitoring target to actively monitor local resources and applications (hard drives, memory, processor statistics etc).

## Zabbix Proxy


**Zabbix proxy** is a process that may collect monitoring data from one or more monitored devices and send the information to the Zabbix server, essentially working on behalf of the server. All collected data is buffered locally and then transferred to the external **Zabbix server** the proxy belongs to.

# Installation

Install requirement [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) and [helm](https://helm.sh/docs/) following the instructions.


# How to Deploy Zabbix in Kubernetes

Add repository:

```bash
helm repo add zabbix-chart-6.0  https://cdn.zabbix.com/zabbix/integrations/kubernetes-helm/6.0
```

Export default values of chart ``helm-zabbix`` to file ``$HOME/zabbix_values.yaml``:

```bash
helm show values zabbix-chart-6.0/zabbix-helm-chrt > $HOME/zabbix_values.yaml
```
Change the values according to the environment in the file ``$HOME/zabbix_values.yaml``.


List the namespaces of cluster.

```bash
kubectl get namespaces
```

Create the namespaces ``monitoring`` if it not exists in cluster.

```bash
kubectl create namespace monitoring
```

Deploy Zabbix in the Kubernetes cluster. (Update the YAML files paths if necessary; Create PVC first if desired).

```bash
helm install zabbix zabbix-chart-6.0/zabbix-helm-chrt --dependency-update -f $HOME/zabbix_values.yaml -n monitoring

```

View the pods.

```bash
kubectl get pods -n monitoring
```

View informations of pods.

```bash
kubectl describe pods/POD_NAME -n monitoring
```

View all containers of pod.

```bash
kubectl get pods POD_NAME -n monitoring -o jsonpath='{.spec.containers[*].name}*'
```

View the logs container of pods.

```bash
kubectl logs -f pods/POD_NAME -c CONTAINER_NAME -n monitoring
```

Access prompt of container.

```bash
kubectl exec -it pods/POD_NAME -c CONTAINER_NAME -n monitoring -- sh
```

# Uninstallation

To uninstall/delete the ``zabbix`` deployment:

```bash
helm delete zabbix -n monitoring
```

# How to access Zabbix

After deploying the chart in your cluster, you can use the following command to access the zabbix proxy service:

View informations of ``zabbix`` services.

View informations of service Zabbix.

```bash
kubectl get svc -n monitoring
kubectl get pods --output=wide -n monitoring
kubectl describe services zabbix -n monitoring
```