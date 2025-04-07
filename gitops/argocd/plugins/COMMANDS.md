# Commands

These are the commands that were run to combine plugins sops, age, and avp.

## Remove AVP Sidecar

```sh
kubectl patch deployment argocd-repo-server -n argocd --patch-file plugins/avp/remove-avp-patch.yaml
```

## Apply CMP Plugin Config

```sh
kubectl apply -f plugins/cmp-plugin.yaml
```

## Apply updated argocd-cm

```sh
envsubst < gitops/argocd/custom-resources/argocd-cm.yaml | kubectl apply -f -
```

## Apply the new deployment patch that includes both SOPS and AVP

```sh
kubectl patch deployment argocd-repo-server -n argocd --patch-file plugins/deployment-patch.yaml
kubectl rollout restart deployment argocd-repo-server -n argocd # should be unnecessary
```
