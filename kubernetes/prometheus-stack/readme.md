```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
Change values file if needed.

```
helm install prometheus-stack prometheus-community/kube-prometheus-stack -f prom-values.yaml
```
