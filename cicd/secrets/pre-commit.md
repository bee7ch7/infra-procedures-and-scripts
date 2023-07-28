Last section with manual bash script to check if file with secrets is encrypted or not
```
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.3.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      # - id: check-added-large-files
      - id: no-commit-to-branch
        args: [--branch, dev, --branch, main]
        #args: ['--pattern', '^(?!((fix|feature|bug|develop)\/[a-zA-Z0-9\-]+)$).*']
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.76.0 # Get the latest from: https://github.com/antonbabenko/pre-commit-terraform/releases
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terragrunt_fmt
      - id: terragrunt_validate
  - repo: local
    hooks:
      - id: secrets-encryption
        name: secrets-encryption
        entry: bash -c 'if ! grep -q ANSIBLE_VAULT "deployment/secrets.txt"; then echo !!! Secrets are not encrypted - USE ANSIBLE-VAULT TO ENCRYPT !!!; exit 1; fi'
        language: system
        pass_filenames: false
```
