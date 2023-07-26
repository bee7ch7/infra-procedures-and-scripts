#!/bin/bash
# Encoded secrets.txt file with ansible-vault
# ansible-vault encrypt secrets.txt

SECRETS_SOURCE=secrets.txt

# Store password from ansible-vault in AWS SSM Parameter store
aws ssm get-parameter --name "/dev/vault-pass"  --with-decryption --output text --query Parameter.Value --region eu-central-1 > ans.vault
ansible-vault decrypt $SECRETS_SOURCE --vault-password-file ans.vault

while read line; do

IFS='=' read -r -a keys <<< $line
var=${keys[0]}
value=${keys[1]}

echo "::add-mask::$value"
export $var=$value # optional
echo $var=$value >> $GITHUB_ENV

done < $SECRETS_SOURCE

echo "Deleting decrypted files and secrets"
rm -f ans.vault
rm -f secrets.txt
