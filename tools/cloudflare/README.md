# Instructions

1. Log-in to cloudflare

    ```bash
    cloudflared login
    ```

2. Create a new tunnel and copy the credentials to the clipboard

    ```bash
    cloudflared tunnel create <tunnel-name>

    # output
    Tunnel credentials written to /Users/timothybryant/.cloudflared/5a526789-1234-be75-54321-12334rfgdfg4.json. cloudflared chose this file based on where your origin certificate was found. Keep this file secret. To revoke these credentials, delete the tunnel.

    Created tunnel n8n with id 5a526789-1234-be75-54321-12334rfgdfg4
    ```

3. Upload tunnel credentials to kubernetes

    ```bash
    kubectl create secret generic tunnel-credentials \
    --from-file=credentials.json=/Users/timothybryant/.cloudflared/5a526789-1234-be75-54321-12334rfgdfg4.json.
    ```

    OR

    ```bash
    # Store credentials in Vault
    apiVersion: v1
    kind: Secret
    metadata:
        annotations:
            avp.kubernetes.io/path: "secret/data/cloudflared"
        name: tunnel-credentials
    type: Opaque
    stringData:
        credentials.json: >-
            <CREDENTIALS>
    ```

4. Associate your Tunnel with a DNS record

    ```bash
    # records are managed by terraform
        resource "cloudflare_record" "terraform_managed_resource_cname" {
    name    = "subdomain"
    proxied = true
    ttl     = 1
    type    = "CNAME"
    value   = "5a526789-1234-be75-54321-12334rfgdfg4.cfargotunnel.com"
    zone_id = var.zone_id
    }
    ```

5. Deploy cloudflared to k8s (see example: `kubernetes-apps/tools/cloudflare/tunnels`)
