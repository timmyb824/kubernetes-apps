# Instructions

https://docs.technotim.live/posts/kube-traefik-cert-manager-le/

## Notes

Upgrade to a specific version of Traefik:

```bash
helm upgrade --namespace=traefik traefik traefik/traefik --values=values.local.yaml --versi
on 10.25.0
```
