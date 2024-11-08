#!/bin/bash

# List of environments to grep for in secret paths
# Secret paths with these string will generate delete commands
envs_to_delete=("DEV" "PROD")

for path in `./vault-list-recursive.sh`; do
    for env in ${envs_to_delete[@]}; do
        if [[ $path =~ $env ]]; then
            path_to_delete=$(echo $path | sed 's![^/]*$!!' | sed 's:/*$::')
            echo "./vault-vac.sh $path_to_delete 1"
        fi
    done
done