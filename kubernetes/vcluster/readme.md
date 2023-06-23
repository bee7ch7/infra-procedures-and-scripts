Add Helm repo:
```
helm repo add loft-sh https://charts.loft.sh
helm repo update
```
Helm install:
```
helm upgrade --install dev-vcluster loft-sh/vcluster -n dev-vcluster --create-namespace -f values.yaml
```
values.yaml:
```
sync:
  ingresses:
    enabled: true # to use single AWS ALB from host cluster
  serviceaccounts:
    enabled: true # to sync serviceaccounts to host cluster to grant IAM permissions
    
vcluster:
  image: rancher/k3s:v1.26.0-k3s1
  
nodeSelector:
  "eks.amazonaws.com/nodegroup: dev-vcluster-ng",
  "env: dev"
      
proxy:
  metricsServer:
    nodes:
      enabled: true
  pods:
     enabled: true
ingress:
      enabled: true,
      pathType: "Prefix",
      apiVersion: "networking.k8s.io/v1",
      ingressClassName: "alb",
      host: dev-vcluster.meldm.ml,
      annotations:
        "alb.ingress.kubernetes.io/backend-protocol: HTTPS"
        "alb.ingress.kubernetes.io/scheme: internal"
        "alb.ingress.kubernetes.io/group.name: internal-apps"
        "alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'"
        "alb.ingress.kubernetes.io/target-type: ip"
        "alb.ingress.kubernetes.io/ssl-redirect: '443'"
        "alb.ingress.kubernetes.io/healthcheck-path: /healthz"
        "alb.ingress.kubernetes.io/load-balancer-name: vcluster-internal-apps"
        "alb.ingress.kubernetes.io/load-balancer-attributes: deletion_protection.enabled=true"
```
Connect to vcluster:
As part of CI\CD, create bash script or step in pipeline
```
#!/bin/bash
curl -L -o vcluster "https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-linux-amd64" \
  && sudo install -c -m 0755 vcluster /usr/local/bin \
  && rm -f vcluster

vcluster connect dev-vcluster -n dev-vcluster &
```
Or from the local machine:
```
vcluster connect dev-vcluster -n dev-vcluster --server=https://dev-vcluster.meldm.ml/  --insecure --update-current=true
or
vcluster connect dev-vcluster -n dev-vcluster --server=https://dev-vcluster.meldm.ml/ --insecure --update-current=false 
```
