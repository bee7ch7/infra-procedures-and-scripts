# Istio service mesh

Add helm repository, save values and customize if needed:
```
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
```
```
helm show values istio/base > istio-base-values.yml
helm show values istio/istiod > istiod-values.yml
```
Install istio-base and istiod:
```
helm install istio-base istio/base --values istio-base-values.yml  -n istio-system --create-namespace
helm install istiod istio/istiod --values istiod-values.yml  -n istio-system --create-namespace
```

Deploy simple applications:
```
k apply -f 1-example/
k apply -f kiali/
```

# `Running Prometheus is required to see graphs in Kiali`
Kiali `config.yaml` contains urls to grafana and prometheus. This should be updated according to the setup
```
...
external_services:
      grafana:
        enabled: true
        in_cluster_url: 'http://grafana.monitoring:3000/'
      prometheus:
        url: http://prometheus-operated.monitoring:9090
...
```

# `PodMonitor is required to monitor istio and display traffic in Kiali`
```
k apply -f monitoring/
```
Read comments inside yaml to have full understanding