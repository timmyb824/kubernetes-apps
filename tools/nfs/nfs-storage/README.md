# Install nfs-subdir-external-provisioner for nfs storage on k3s

## Add the repo

```powershell
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner

helm repo update
```

## Install from the repo

```powershell
helm install nfs-synologynas nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=$SERVER --set nfs.path=/volume1/kubernetes --set storageClass.name=nfs-csi-synologynas --set storageClass.defaultClass=true
```

## Create storageClass

```powershell
kubectl create -f storageClass.yaml
```
