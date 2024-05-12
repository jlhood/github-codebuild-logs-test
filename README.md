# github-codebuild-logs-test

Repo for integ testing github-codebuild-logs apps prior to publishing to SAR.

## Usage

1. In github-codebuild-logs repo, run `PACKAGE_BUCKET=<publishing bucket> PROFILE=<aws credential profile> make package`. Output will include full path to packaged template. Copy this path.
1. Go to [https://github.com/settings/tokens](https://github.com/settings/tokens) and create a new token that has `repo` access. Copy the created token.
1. In this repo, run `bin/deploy.sh <aws credential profile> <path to packaged template> <GitHub token>`. This updates the CodeBuild projects and test stacks.
1. In this repo, make a dummy change, e.g., update the README, commit and push to a remote branch, i.e., `git push origin HEAD:test`.
1. Create a PR for the dummy change. Wait for CodeBuild runs to finish and verify comments are posted to the PR and work as expected.
1. Once finished, close the test PR, delete the branch.
