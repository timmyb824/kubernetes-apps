#!/bin/bash

# Initialize vault-0 with one key share and one key threshold.
# It appears this only needs to be done once at install time.
kubectl exec vault-0 -n vault -- vault operator init \
    -key-shares=1 \
    -key-threshold=1 \
    -format=json > cluster-keys.json

# Display the unseal key found in cluster-keys.json.
jq -r ".unseal_keys_b64[]" cluster-keys.json

# Create a variable named VAULT_UNSEAL_KEY to capture the Vault unseal key.
VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" cluster-keys.json)

# Unseal Vault running on the vault-0 pod.
kubectl exec vault-0 -n vault -- vault operator unseal "$VAULT_UNSEAL_KEY"