#!/bin/bash

checkrot () {
    local keyid=$1
    local profile=$2
    local status=$(aws kms get-key-rotation-status --key-id $keyid --profile $profile 2> /dev/null)
    local statusError=$?
    local rotated=''
    local description=''
    local descriptionError=''

    if [ $statusError -eq 0 ]; then
        rotated=$(echo $status | jq '.KeyRotationEnabled')
        if [ "$rotated" = "false" ]; then 
            description=$(aws kms describe-key --key-id $keyid --profile $profile 2>&1)
            descriptionError=$?
            if [ $descriptionError -eq 0 ]; then
                echo $description | jq --arg foo $rotated '.KeyMetadata + {isAutoRotated: $foo}'
            fi
        fi
    fi
}

profile=$1
aws kms list-keys --profile $profile | jq '.Keys | .[] | .KeyId' | tr -d '"' | \
while read -r line; do
    checkrot $line $profile
done
