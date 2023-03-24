# Installation

Documentation: https://developer.hashicorp.com/vault/docs/platform/k8s/helm/run

```bash
helm repo add hashicorp https://helm.releases.hashicorp.com

helm install vault hashicorp/vault

helm install vault hashicorp/vault --values values.local.yaml -n vault

helm upgrade vault hashicorp/vault --version=0.23.0 \
    --set='server.image.repository=vault' \
    --set='server.image.tag=123.456' \
    --dry-run \
    -n vault
```

## Configuration

After helm chart is installed the following configuration is required:

Documentation: https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-raft?in=vault%2Fkubernetes

```bash
# Unseal vault

# Initialize vault-0 with one key share and one key threshold.
kubectl exec vault-0 -- vault operator init \
    -key-shares=1 \
    -key-threshold=1 \
    -format=json > cluster-keys.json

# Display the unseal key found in cluster-keys.json.
jq -r ".unseal_keys_b64[]" cluster-keys.json

# Create a variable named VAULT_UNSEAL_KEY to capture the Vault unseal key.
VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" cluster-keys.json)

# Unseal Vault running on the vault-0 pod.
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
# The operator unseal command reports that Vault is initialized and unsealed.
```

```bash
# Set web application secret

# display root token
jq -r ".root_token" cluster-keys.json

# start interactive shell
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh

# login with root token
vault login

# Enable an instance of the kv-v2 secrets engine at the path secret.
vault secrets enable -path=secret kv-v2

# Create a secret at path secret/webapp/config with a username and password.
vault kv put secret/webapp/config username="static-user" password="static-password"

# Verify that the secret is defined at the path secret/webapp/config.
vault kv get secret/webapp/config
# You successfully created the secret for the web application.
```

```bash
# Create AppRole via API

# Enable the AppRole auth method:
curl \
    --header "X-Vault-Token: $VAULT_ROOT_TOKEN" \
    --request POST \
    --data '{"type": "approle"}' \
    https://vault.local.timmybtech.com/v1/sys/auth/approle

# Create an AppRole with desired set of policies:
curl \
    --header "X-Vault-Token: $VAULT_ROOT_TOKEN" \
    --request POST \
    --data '{"policies": "default"}' \
    https://vault.local.timmybtech.com/v1/auth/approle/role/argocd

#  Fetch the identifier of the role:
curl \
    --header "X-Vault-Token: $VAULT_ROOT_TOKEN" \
        https://vault.local.timmybtech.com/v1/auth/approle/role/argocd/role-id


# Create a new secret identifier under the role:
curl \
    --header "X-Vault-Token: $VAULT_ROOT_TOKEN" \
    --request POST \
     https://vault.local.timmybtech.com/v1/auth/approle/role/argocd/secret-id

```

## Other Commands

```bash
# Update policies of an approle
vault write auth/approle/role/argocd policies=default,avp

# show details of an approle
kubectl exec vault-0 -n vault -- vault read auth/approle/role/argocd
```