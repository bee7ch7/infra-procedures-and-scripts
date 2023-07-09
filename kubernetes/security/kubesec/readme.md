Static YAML file security scanner:

https://kubesec.io/

Installation:

```
wget https://github.com/controlplaneio/kubesec/releases/download/v2.11.0/kubesec_linux_amd64.tar.gz
tar -xvf  kubesec_linux_amd64.tar.gz
mv kubesec /usr/bin/
```

Scan yaml file:

```kubesec scan /root/node.yaml```

```kubesec scan ./deployment.yaml```

```cat file.json | kubesec scan -```

Or whole Helm chart:
```helm template -f values.yaml ./chart | kubesec scan /dev/stdin```
