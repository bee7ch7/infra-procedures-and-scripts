Helm values for simple setup:
`values.yaml` =>
```
ui:
  enabled: true
server:
  affinity: ""
  ha:
    enabled: true
    raft:
      enabled: true
      setNodeId: true
      config: |
        ui = true
        cluster_name = "vault-integrated-storage"
        storage "raft" {
           path    = "/vault/data/"
        }

        listener "tcp" {
           address = "[::]:8200"
           cluster_address = "[::]:8201"
           tls_disable = "true"
        }
        service_registration "kubernetes" {}
```
Helm install:
```
helm upgrade --install vault-central hashicorp/vault:1.17.2 -f values.yml
```

Init vault and note root token and unseal token:
```
vault operator init -key-shares=1 -key-threshold=1
```
Join other vault pods:
```
vault operator raft join http://vault-central-0.vault-central-internal:8200
```
Unseal vault with unseal token from step above:
```
vault operator unseal 
```
