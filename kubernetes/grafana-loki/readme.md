# Loki
Collect pods only from pods with label `logs: collect`

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-1
  # namespace: prod
  labels:
    app: nginx-1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-1
  template:
    metadata:
      labels:
        app: nginx-1
        logs: collect
    spec:
      containers:
      - name: nginx
        image: nginx:latest
```

# Create secrets to access S3 bucket or use service account and role
```
kubectl create secret generic iam-loki-s3 --from-literal=AWS_ACCESS_KEY_ID='AKIxxxxxx' --from-literal=AWS_SECRET_ACCESS_KEY='3pxxxxx' -n default
```

# Install grafana-loki stack
```
helm install loki-stack grafana/loki-stack --values values.yaml

```
# Access the Grafana Web UI
```
kubectl port-forward svc/loki-stack-grafana -n default 8080:80
```
```
kubectl get secret --namespace default loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
