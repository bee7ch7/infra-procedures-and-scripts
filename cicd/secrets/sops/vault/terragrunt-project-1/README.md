# Using Terragrunt with SOPS and Hashicorp Vault

Secrets used in S3 bucket name to simplify things

To encrypt or decrypt file locally:
```
export VAULT_ADDR=https://vault-url
export VAULT_TOKEN=s.324gsdfas324.13gfd
```

In the `.sops.yaml` file you have to update the rules to reflect your environments, and also specify the Vault instance to be used:

```
creation_rules:
  - path_regex: environments(/|\\)eu-central-1(/|\\)dev(/|\\)secrets(/|\\).*\.yaml(\.unencrypted)?$
    hc_vault_transit_uri: "https://vault-url/<namespace>/sops/keys/first_key"
  - path_regex: environments(/|\\)eu-central-1(/|\\)prod(/|\\)secrets(/|\\).*\.yaml(\.unencrypted)?$
    hc_vault_transit_uri: "https://vault-url/<namespace>/sops/keys/second_key"
```
- Create a `transit engine` named sops.
- Create a new key for encrypting and decrypting SOPS secrets for every environment using `rsa-4096` algorithm for the key
- Create new policies and 
``` hcl
path "sops/decrypt/<key-name>" {
  capabilities = [ "update" ]
}
```
``` hcl
path "sops/encrypt/<key-name>" {
  capabilities = [ "update" ]
}
```

Commands to encrypt files:
```
bash sops_encrypt.sh environments/eu-central-1/prod/secrets/google_creds.yaml.unencrypted
```