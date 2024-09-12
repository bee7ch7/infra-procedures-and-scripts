Backup cronjob for HashiCorp Vault (Raft):

Create policy:
```
echo '
path "sys/storage/raft/snapshot" {
   capabilities = ["read"]
}' | vault policy write snapshot -
```

Create approle:
```
vault auth enable approle
vault write auth/approle/role/snapshot-agent token_ttl=2h token_policies=snapshot
vault read auth/approle/role/snapshot-agent/role-id
vault write -f auth/approle/role/snapshot-agent/secret-id
```
Note `role_id` and `secret_id`

Create Kubernetes secret with role and secret:
```
apiVersion: v1
kind: Secret
metadata:
  name: vault-snapshot-agent-token
stringData:
  VAULT_APPROLE_ROLE_ID: 39e23b13-bfb6-9236-0ef7-3bf56b3cd1d7
  VAULT_APPROLE_SECRET_ID: 29888079-d951-1bb3-6f28-bda29c002efe
```

Creat Kubernetes secret with AWS credentials if used on-premises, othewise use service account with IAM role:
```
apiVersion: v1
kind: Secret
metadata:
  name: vault-snapshot-s3
stringData:
  AWS_ACCESS_KEY_ID: xxxx
  AWS_SECRET_ACCESS_KEY: xxxx
  AWS_DEFAULT_REGION: eu-central-1
```

Create Kubernetes CronJob:
```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: vault-snapshot-cronjob
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          volumes:
            - name: share
              emptyDir: {}
          containers:
            - name: snapshot
              image: hashicorp/vault:1.17.2
              imagePullPolicy: IfNotPresent
              command:
                - /bin/sh
              args:
                - "-ec"
                - |
                  export VAULT_TOKEN=$(vault write auth/approle/login role_id=$VAULT_APPROLE_ROLE_ID secret_id=$VAULT_APPROLE_SECRET_ID -format=json | grep '"client_token"' | sed 's/.*"client_token": "\(.*\)",/\1/');
                  vault operator raft snapshot save /share/vault-raft.snap;
              envFrom:
                - secretRef:
                    name: vault-snapshot-agent-token
              env:
                - name: VAULT_ADDR
                  value: http://vault-central.vault.svc.cluster.local:8200
              volumeMounts:
                - mountPath: /share
                  name: share
            - name: upload
              image: amazon/aws-cli:2.17.49
              imagePullPolicy: IfNotPresent
              command:
                - /bin/sh
              args:
                - "-ec"
                - |
                  until [ -f /share/vault-raft.snap ]; do sleep 5; done;
                  aws s3 cp /share/vault-raft.snap s3://syncsoul-vault-backup-eu-central-1/vault_raft_$(date +"%Y%m%d_%H%M%S").snap;
              envFrom:
                - secretRef:
                    name: vault-snapshot-s3
              volumeMounts:
                - mountPath: /share
                  name: share
          restartPolicy: OnFailure
```
