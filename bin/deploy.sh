#!/bin/sh

#
# Deploys given github-codebuild-logs app template to 4 test stacks to test the following cases:
#
#  1. github-codebuild-logs-test-codebuild-oauth-success - Gets GitHub OAuth token from CodeBuild project, build succeeds.
#  2. github-codebuild-logs-test-codebuild-oauth-failure - Gets GitHub OAuth token from CodeBuild project, build fails.
#  3. github-codebuild-logs-test-oauth-param-success - Gets GitHub OAuth token from app parameter, build succeeds.
#  4. github-codebuild-logs-test-oauth-param-failure - Gets GitHub OAuth token from app parameter, build fails.
#

usage() {
    echo "Usage: deploy.sh <profile> <packaged app template path> <GitHub OAuth Token>" 1>&2
    exit 1
}

if [ $# -ne 3 ] ; then
    echo "Error: Wrong number of arguments" 1>&2
    usage
fi

PROFILE=$1
TEMPLATE_PATH=$2
OAUTH_TOKEN=$3

aws codebuild update-project \
    --profile $PROFILE \
    --name github-codebuild-logs-test-codebuild-oauth-success \
    --source '{"type":"GITHUB","location":"https://github.com/jlhood/github-codebuild-logs-test.git","gitCloneDepth":1,"buildspec":"buildspec-success.yml","auth":{"type":"OAUTH","resource":"'$OAUTH_TOKEN'"},"reportBuildStatus":true,"insecureSsl":false}'

sam deploy \
    --profile $PROFILE \
    --template-file $TEMPLATE_PATH \
    --stack-name github-codebuild-logs-test-codebuild-oauth-success \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides \
        CodeBuildProjectName=github-codebuild-logs-test-codebuild-oauth-success \
        LogLevel=DEBUG

aws codebuild update-project \
    --profile $PROFILE \
    --name github-codebuild-logs-test-codebuild-oauth-failure \
    --source '{"type":"GITHUB","location":"https://github.com/jlhood/github-codebuild-logs-test.git","gitCloneDepth":1,"buildspec":"buildspec-failure.yml","auth":{"type":"OAUTH","resource":"'$OAUTH_TOKEN'"},"reportBuildStatus":true,"insecureSsl":false}'

sam deploy \
    --profile $PROFILE \
    --template-file $TEMPLATE_PATH \
    --stack-name github-codebuild-logs-test-codebuild-oauth-failure \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides \
        CodeBuildProjectName=github-codebuild-logs-test-codebuild-oauth-failure \
        LogLevel=DEBUG

sam deploy \
    --profile $PROFILE \
    --template-file $TEMPLATE_PATH \
    --stack-name github-codebuild-logs-test-oauth-param-success \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides \
        CodeBuildProjectName=github-codebuild-logs-test-oauth-param-success \
        LogLevel=DEBUG \
        GitHubOAuthToken=$OAUTH_TOKEN

sam deploy \
    --profile $PROFILE \
    --template-file $TEMPLATE_PATH \
    --stack-name github-codebuild-logs-test-oauth-param-failure \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides \
        CodeBuildProjectName=github-codebuild-logs-test-oauth-param-failure \
        LogLevel=DEBUG \
        GitHubOAuthToken=$OAUTH_TOKEN
