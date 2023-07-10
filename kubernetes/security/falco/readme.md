Falco

https://falco.org/docs/getting-started/installation/

Falco can be used for Kubernetes runtime security. The most secure way to run Falco is to install Falco directly on the host system so that Falco is isolated from Kubernetes in the case of compromise. Then the Falco alerts can be consumed through read-only agents running in Kubernetes.

You can also run Falco directly in Kubernetes as a Daemonset using Helm, see the third-party integrations
