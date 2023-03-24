# Set up 'nfs-subdir-external-provisioner' for nfs storage on k3s

<https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner>

1) Add and install from the helm repo

```bash
# add the repo
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner

helm repo update
```

```bash
# install from the repo
helm install nfs-synologynas nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=192.168.86.44 --set nfs.path=/volume1/kubernetes --set storageClass.name=nfs-csi-synologynas --set storageClass.defaultClass=true
```

2) Install `nfs-common` on all nodes

```bash
sudo apt install nfs-common
```

Not doing this can result in strange errors like `bad option; for several filesystems (e.g. nfs, cifs) you might need a /sbin/mount.type helper program.`
