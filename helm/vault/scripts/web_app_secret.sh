#!/bin/bash

TOKEN=$(jq -r ".root_token" cluster-keys.json)

# login with root token
kubectl exec vault-0 -n vault -- vault login $TOKEN

# Enable an instance of the kv-v2 secrets engine at the path secret.
kubectl exec vault-0 -n vault -- vault secrets enable -path=secret kv-v2

# Create a secret at path secret/webapp/config with a username and password."
kubectl exec vault-0 -n vault -- vault kv put secret/webapp/config username="$ZUSER" password="$ZPASSWORD"

# Verify that the secret is defined at the path secret/webapp/config.
kubectl exec vault-0 -n vault -- vault kv get secret/webapp/config
