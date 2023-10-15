# Create self-hosted Github Runner in docker

Update ```Dockerfile``` for needed packages and GitHub runner version.

Get latest runner id:
https://github.com/actions/runner/releases

```
docker build --tag github-runner .
```

Run:
```
docker run \
  --detach \
  --env ORGANIZATION=<org_name> \
  --env ACCESS_TOKEN=<PAT> \
  --name github-runner \
  github-runner
```

Credits:
https://testdriven.io/blog/github-actions-docker/