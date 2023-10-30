# Summary

Real-time Kubernetes protocol-level visibility, capturing and monitoring all traffic going in, out and across containers, pods, namespaces, nodes and clusters.

## Homelab

I currently have [Kubeshark](https://www.kubeshark.co/) installed locally using pkgx. It can also be installed using homebrew, a shell script, or helm. Additionally, there are integrations with tools like Lens and Grafana.

## Commands

```bash

# methods of starting
kubeshark tap
kubeshark tap -n namepsace
kubeshark tap pod-123
kubeshark tap "(back-end*|front-end*)"

# use proxy instead of port-forwardig for dashboard
kubeshark proxy

# completely wipe from cluster
kubeshark clean
```
