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
    echo "Usage: deploy.sh <packaged app template path> <GitHub OAuth Token>" 1>&2
    exit 1
}

if [ "$#" != "2" ] ; then
    echo "Error: Wrong number of arguments" 1>&2
    usage
fi

TEMPLATE_PATH=$1
OAUTH_TOKEN=$2

sam deploy \
    --template-file $TEMPLATE_PATH \
    --stack-name github-codebuild-logs-test-codebuild-oauth-success \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides \
        CodeBuildProjectName=github-codebuild-logs-test-codebuild-oauth-success

sam deploy \
    --template-file $TEMPLATE_PATH \
    --stack-name github-codebuild-logs-test-codebuild-oauth-failure \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides \
        CodeBuildProjectName=github-codebuild-logs-test-codebuild-oauth-failure
