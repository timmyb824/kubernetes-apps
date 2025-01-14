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
kubectl exec --stdin=true --tty=true vault-0 -n vault -- /bin/sh

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

# create secret
vault kv put engine/path key=value

# read secret
vault kv get engine/path

# update secret
vault kv patch engine/path key=value

# delete secret
vault kv delete engine/path

# destroy secret
vault kv destroy engine/path

# list secrets
vault kv list shared/mailing_list

# rollback to previous version of secret
vault kv -version=# engine/path

# undelete secret
vault kv undelete engine/path

# show metadata of secret
vault kv metadata get engine/path
```

The delete subcommand does a "soft" delete; will not return the value during a `get`. A user can still `undelete` the value if required. The `destory` removes the value entirely.

Due to the additional versioning of kv pairs in v2, `rollback` allows a user to go back to a previous version of a key. The version info is visible via the `metadata` command.

Options for hiding a secret in the shell history:

```bash
# Using JSON
echo -n '{"key":"value"}' | vault kv put engine/path  -
vault kv put engine/path @data.json

# Using simple value
echo -n "value" | vault kv put engine/path key=-
vault kv put engine/path key=@data.txt
```

## OIDC Configuration

Authentik OIDC Configuration

```bash
# enable OIDC method
kubectl exec vault-0 -n vault -- vault auth enable oidc

# configure OIDC
kubectl exec vault-0 -n vault -- vault write auth/oidc/config oidc_discovery_url="https://authentik.local.timmybtech.com/application/o/vault/" oidc_client_id="<client_id>" oidc_client_secret="<client_secret>" default_role="reader"

# create reader role
kubectl exec vault-0 -n vault -- vault write auth/oidc/role/reader bound_audiences="<client_id>" allowed_redirect_uris="https://vault.local.timmybtech.com/ui/vault/auth/oidc/oidc/callback" allowed_redirect_uris="https://vault.local.timmybtech.com/ui/vault/auth/oidc/callback" allowed_redirect_uris="http://localhost:8250/oidc/callback" user_claim="sub" policies="reader"

# create super-admin role
kubectl exec vault-0 -n vault -- vault write auth/userpass/users/tbryant policies=super-admin

# add super-admin to reader (allows oicd user to edit everything)
kubectl exec vault-0 -n vault -- vault write auth/oidc/role/reader policies="reader, super-admin"
```
