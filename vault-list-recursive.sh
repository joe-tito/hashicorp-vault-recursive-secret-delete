#!/bin/bash
#
# Usage:
#
#   vault-list-recurive.sh START_PATH

set -euo pipefail

to_lines() {
    sed "s/{}//g" \
    | sed "s/^-\ //g" \
    | xargs -L1
}

prefix() {
  if [[ $# < 1 ]]; then
    echo prefix PREFIX >&2
    return 1
  fi
  
  sed s@"^"@"$1"@
}

vault_list_secrets() {
  vault secrets list | tail -n +3 | awk '{print $1}'
}

vault_list() {
  if [[ $# < 1 ]]; then
    echo vault_list PATH >&2
    return 1
  fi

  start_path="$1"
  
  if [[ "$start_path" == "" ]]; then
    echo vault_list PATH >&2
    return 1
  fi
  
  if ! vault kv list -format yaml "$start_path" | to_lines | prefix "$start_path"; then
    # echo "failed: vault kv list ${start_path@Q}"
    return 1
  fi
}

vault_list_recursive() {
  if [[ $# < 1 ]]; then
    echo vault_list_recursive PATH >&2
    return 1
  fi

  start_path="$1"
  
  if [[ "$start_path" == "" ]]; then
    echo vault_list_recursive PATH >&2
    return 1
  fi  
  
  ( vault_list "$start_path" || true ) | while read path
  do
    if [[ ${path: -1} != "/" ]]; then
      echo "$path"
    else 
      vault_list_recursive "$path"
    fi
  done  
}

usage() {
  echo $(basename $0): START_PATH >&2
  exit 1
}

start_path="${1:-}"
if [[ ${start_path: -1} != "/" ]]; then
  start_path="$start_path/"
fi


if [[ "$start_path" == "/" ]]; then 
  vault_list_secrets | while read -r secret; do
    vault_list_recursive "$secret" 
  done
else
  vault_list_recursive "$start_path"
fi