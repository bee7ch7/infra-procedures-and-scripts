#!/bin/bash

if [[ "x${VAULT_TOKEN}" == "x" ]]; then
  echo "VAULT_TOKEN was not provided. Decryption token needs to be provided as VAULT_TOKEN environmental variable. Exiting..."
  exit -1
fi

RESULT_FILE=$(echo "${1}.unencrypted")
if [[ ${1: -4} == ".env" ]]; then
  echo "dotenv file found"
  sops -d --input-type=dotenv --output-type=dotenv $1 > $RESULT_FILE
elif [[ ${1: -5} == ".json" ]]; then
  echo "json file found"
  sops -d --input-type=json --output-type=json $1 > $RESULT_FILE
elif [[ ${1: -5} == ".yaml" ]]; then
  echo "yaml file found"
  sops -d --input-type=yaml --output-type=yaml $1 > $RESULT_FILE
else
  echo "generic file found"
  sops -d $1 > $RESULT_FILE
fi
echo "Successfully unencrypted secret to $RESULT_FILE"