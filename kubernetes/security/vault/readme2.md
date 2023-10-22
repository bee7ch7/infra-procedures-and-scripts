`Enable secrets engine`

```
vault secrets enable -path=stage/kv kv-v2
```
`Create policies`
```
path "stage/kv/stage*" {
   capabilities = ["list"]
}
path "stage/kv/stage/db_*" {
   capabilities = [ "create", "read", "update", "delete", "list" ]
}
```

`Write policies`
```
vault policy write stage-db -<<EOF
path "stage/kv/stage*" {
   capabilities = ["list"]
}
path "stage/kv/stage/db_*" {
   capabilities = [ "create", "read", "update", "delete", "list" ]
}
EOF
```
`Enable auth method:`

```
vault auth enable -path="userpass-test" userpass
```

`Create user and attache policy:`
```
vault write auth/userpass-test/users/bob password="pass" policies="stage-db"
```

