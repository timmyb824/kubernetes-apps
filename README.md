# Summary

This repository contains a collection of Kubernetes applications that are currently deployed in my home Kubernetes cluster, or that I tested in the past.

## Applications

The folders are broken out by method of deployment. The `gitops` folder contains applications that are deployed via [ArgoCD](https://argoproj.github.io/argo-cd/), the `helm` folder contains applications that are deployed via [Helm](https://helm.sh/), and the `manifests` folder contains applications that are deployed via `kubectl apply -f`. Finally, the `tools` folder contains instructions for installing tools that are used to to help manage things within the cluster.

## Cluster

Currently, my cluster consists of 3 control plane nodes and 3 worker nodes. The control plane nodes are running Ubuntu 20.04, and the worker nodes are running Ubuntu 20.04. The cluster is managed by [k3s](https://k3s.io/), and is deployed via ansible. The ansible playbooks are available within my `automations` repo here [k3s-ansible](https://github.com/timmyb824/automations/tree/main/ansible/k3s).
