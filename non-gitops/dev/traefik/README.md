# Instructions

https://docs.technotim.live/posts/kube-traefik-cert-manager-le/

## Notes

Upgrade to a specific version of Traefik:

```bash
# last run June 4, 2024
helm upgrade --namespace=traefik traefik traefik/traefik --values=values.local.yaml --versi
on 27.0.0
```
