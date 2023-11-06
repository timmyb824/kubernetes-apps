# Installation

## Initial install

```bash
helm install netdata netdata/netdata \
  --set parent.claiming.enabled="true" \
  --set parent.claiming.token=TOKEN_HERE \
  --set parent.dnsPolicy="" \
  --set child.claiming.enabled="true" \
  --set child.claiming.token=TOKEN_HERE \
  --set child.dnsPolicy="ClusterFirstWithHostNet"
```

OR

```bash
# newer version
helm install netdata netdata/netdata \
--set image.tag=edge \
--set parent.claiming.enabled="true" \
--set parent.claiming.token=${TOKEN} \
--set parent.claiming.rooms=${CLAIM_ROOM} \
--set child.claiming.enabled="true" \
--set child.claiming.token=${TOKEN} \
--set child.claiming.rooms=${CLAIM_ROOM} \
```

OR

`helm install netdata netdata/netdata -f override.yaml`

## Update running pods

`helm upgrade -f override.yaml netdata netdata/netdata`

## Delete everything

`helm delete netdata`

## Default storage error (remove default annotation from local-path)

`kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'`

