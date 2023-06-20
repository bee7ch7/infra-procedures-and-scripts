To connect to the network via SSH and use tunnel as VPN:
```
ssh -i ~/.ssh/jumpbox.pem -L 0.0.0.0:8000:10.10.14.251:8000 \
-L 0.0.0.0:6432:postgtesql.us-east-1.rds.amazonaws.com:5432 \
ubuntu@PUBLIC_IP
```
```-L 0.0.0.0:8000:10.10.14.251:8000``` - listen on laptop (localhost) in all interfaces at 0.0.0.0:8000 and proxy to the remote 10.10.14.251:8000

```-L 0.0.0.0:6432:postgtesql.us-east-1.rds.amazonaws.com:5432``` - listen on laptop (localhost) in all interfaces at 0.0.0.0:6432 and proxy to the remote postgtesql.us-east-1.rds.amazonaws.com:5432
