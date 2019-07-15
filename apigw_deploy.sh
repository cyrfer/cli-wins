#!/bin/bash

forceDeploy () {
    local stackName="$1"
    local awsProfile="$2"
    local stageName="$3"
    local restApiId=''
    local cmd=''
    local out=0

    export AWS_DEFAULT_REGION="us-west-2"
    local stackInfo=$(aws cloudformation describe-stacks --stack-name $stackName --profile $awsProfile)
    out=$?
    if [ $out -gt 0 ]; then
        echo "describe-stacks failed with code $out"
        return $out
    fi

    restApiId=$(echo $stackInfo | python getStackOutput.py RestApiId)
    out=$?
    if [ $out -gt 0 ]; then
        echo "parsing stack output failed with code $out"
        return $out
    fi

    cmd=$(echo aws apigateway create-deployment --rest-api-id "$restApiId" --stage-name "$stageName" --profile "$awsProfile")
    echo "$cmd"
    aws apigateway create-deployment --rest-api-id "$restApiId" --stage-name "$stageName" --profile "$awsProfile"
}

# example usage:
# apigw_deploy.sh contentnow-dev default 1
forceDeploy "$1" "$2" "$3"
