Add helm repository:
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm search repo jetstack
```
Select latest version:
```
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.13.1 --set installCRDs=true
```
Create secret with AWS credentials if using cert-manager `outside` AWS account:
```
kubectl create secret generic acme-route53 --from-literal=secret-access-key=3p7xxxxxxxxx -n cert-namager
```
In order to verify configuration it is recommended to test at staging first.
Apply cluster-issuer-staging.yaml:
```
k apply -f cluster-issuer-staging.yaml
```

Create application - deployment and service:
```
k apply -f application.yaml
```

Create ingress for `staging` and if certificate issued successfully create for `prod`:
```
k apply -f ingress-staging.yaml
k apply -f ingress-prod.yaml
```

If validation is not passing due to `REFUSE` error from AWS DNS, add this argument to the `cert-manager` deployment:

```
spec:
      containers:
        - name: cert-manager-controller
          image: quay.io/jetstack/cert-manager-controller:v1.13.1
          args:
            ...
            - '--dns01-recursive-nameservers="8.8.8.8:53"'
            - '--dns01-recursive-nameservers-only'
          ports:
```