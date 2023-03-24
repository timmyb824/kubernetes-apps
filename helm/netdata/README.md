# Installation

## Initial install

helm install netdata netdata/netdata \
  --set parent.claiming.enabled="true" \
  --set parent.claiming.token=TOKEN_HERE \
  --set parent.dnsPolicy="" \
  --set child.claiming.enabled="true" \
  --set child.claiming.token=TOKEN_HERE \
  --set child.dnsPolicy="ClusterFirstWithHostNet"

OR

helm install netdata netdata/netdata -f override.yaml

## Update running pods

helm upgrade -f override.yaml netdata netdata/netdata

## Delete everything

helm delete netdata

## Default storage error (remove default annotation from local-path)

kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
