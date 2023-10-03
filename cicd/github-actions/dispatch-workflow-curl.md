```
curl -L -s -w "%{http_code}" -X POST \
-H "Accept: application/vnd.github+json"   \
-H "Authorization: Bearer ghp_YOUR_PAT"   \
-H "X-GitHub-Api-Version: 2022-11-28"   \
https://api.github.com/repos/bee7ch7/private-curl/actions/workflows/manual.yaml/dispatches \
-d '{"ref":"main","inputs":{"logLevel":"info","branch_name":"feature/mybranch-re314", "destroy":"false"}}'
```
