Install vault:
```
wget https://releases.hashicorp.com/vault/1.14.0/vault_1.14.0_linux_amd64.zip
unzip vault_1.14.0_linux_amd64.zip
```
Enable key-value plugin:
```
vault secrets enable kv-v2
```
Enable userpass authentication method:
```
vault auth enable userpass
or 
vault auth enable -path="dev-users" userpass
```

Create user:
```
vault write auth/userpass/users/dm password=1234
```

Create policies:
```
tee my-policy.hcl <<EOF
path "secrets/*" {
  capabilities = ["create", "update", "read"]
}

path "kv/*" {
  capabilities = ["create", "update", "read"]
}
EOF
```

```
vault policy write kv-management ./my-policy.hcl
```

Assign policy to user:
```
vault write auth/userpass/users/dm/policies policies="kv-management"
```
Login to vault using username and password:
```
vault login -method=userpass username=dm password=1234
```
