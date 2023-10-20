#!/bin/bash

realpath()
{
    pushd $(dirname "$1") &> /dev/null

    if [[ $(basename "$1") == "" || $(basename "$1") == "." ]]; then
      echo $(pwd -P)
    else
      echo $(pwd -P)/$(basename "$1")
    fi

    popd > /dev/null
}

SCRIPT_PATH="$(realpath "${BASH_SOURCE[-1]}")"
BASE_PATH="$(dirname "${SCRIPT_PATH}")"
SECRET_PATH=$(realpath $1)

echo "Repo path: $BASE_PATH"
echo "Unencrypted secret path: $SECRET_PATH"
if [[ $SECRET_PATH != $BASE_PATH* ]]; then
  echo "Secret file is not in the same repository. Exiting..."
  exit -1
fi

RELATIVE_PATH=${SECRET_PATH:$(echo $BASE_PATH | wc -c)}
RELATIVE_PATH_PARTS=(${RELATIVE_PATH//\// })
ENV_NAME=${RELATIVE_PATH_PARTS[1]}
echo "Environment name: ${ENV_NAME}"

if [[ "x${VAULT_TOKEN}" == "x" ]]; then
  VAULT_TOKEN_PATH=.vault_token_$(echo ${ENV_NAME} | tr - _)
  echo "Setting VAULT_TOKEN from ${VAULT_TOKEN_PATH} file"
  export VAULT_TOKEN=$(cat ${VAULT_TOKEN_PATH} | tr -d '\r\n')
else
  echo "Using VAULT_TOKEN provided as env var"
fi

RESULT_FILE=$(echo $1 | sed 's/\.unencrypted$//')
if [[ ${1: -16} == ".env.unencrypted" ]]; then
  echo "dotenv file found"
  sops -e --input-type=dotenv --output-type=dotenv $1 > $RESULT_FILE
elif [[ ${1: -17} == ".json.unencrypted" ]]; then
  echo "json file found"
  sops -e --input-type=json --output-type=json $1 > $RESULT_FILE
elif [[ ${1: -17} == ".yaml.unencrypted" ]]; then
  echo "yaml file found"
  sops -e --input-type=yaml --output-type=yaml $1 > $RESULT_FILE
else
  echo "generic file found"
  sops -e $1 > $RESULT_FILE
fi
echo "Successfully encrypted secret to $RESULT_FILE"