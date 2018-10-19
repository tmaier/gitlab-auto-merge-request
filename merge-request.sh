#!/usr/bin/env bash
set -e

if [ -z "$GITLAB_PRIVATE_TOKEN" ]; then
  echo "GITLAB_PRIVATE_TOKEN not set"
  echo "Please set the GitLab Private Token as GITLAB_PRIVATE_TOKEN"
  exit 1
fi

# Conditional commit prefix, etc: WIP
if [ -z "$COMMIT_PREFIX" ]; then
  COMMIT_TITLE="${CI_COMMIT_REF_NAME}"
else
  COMMIT_TITLE="${COMMIT_PREFIX}: ${CI_COMMIT_REF_NAME}"
fi

# Conditional remove branch after merge
if [ -z "$REMOVE_BRANCH_AFTER_MERGE" ]; then
  REMOVE_BRANCH_AFTER_MERGE=false
fi

# Extract the host where the server is running, and add the URL to the APIs
[[ $CI_PROJECT_URL =~ ^https?://[^/]+ ]] && HOST="${BASH_REMATCH[0]}/api/v4/projects/"

# Look which is the default branch
TARGET_BRANCH=`curl --silent "${HOST}${CI_PROJECT_ID}" --header "PRIVATE-TOKEN:${GITLAB_PRIVATE_TOKEN}" | jq --raw-output '.default_branch'`;

# If Source and Target branch is same then exit.
if [ "${CI_COMMIT_REF_NAME}" -eq "${TARGET_BRANCH}" ]; then
  echo "Source and Target branch is must be different!"
  echo "Source: ${CI_COMMIT_REF_NAME}"
  echo "Target: ${TARGET_BRANCH}"
  exit 1
fi

# The description of our new MR, we want to remove the branch after the MR has
# been closed
BODY="{
    \"id\": ${CI_PROJECT_ID},
    \"source_branch\": \"${CI_COMMIT_REF_NAME}\",
    \"target_branch\": \"${TARGET_BRANCH}\",
    \"remove_source_branch\": \"${REMOVE_BRANCH_AFTER_MERGE}\",
    \"title\": \"${COMMIT_TITLE}\",
    \"assignee_id\":\"${GITLAB_USER_ID}\"
}";

# Require a list of all the merge request and take a look if there is already
# one with the same source branch
LISTMR=`curl --silent "${HOST}${CI_PROJECT_ID}/merge_requests?state=opened" --header "PRIVATE-TOKEN:${GITLAB_PRIVATE_TOKEN}"`;
COUNTBRANCHES=`echo ${LISTMR} | grep -o "\"source_branch\":\"${CI_COMMIT_REF_NAME}\"" | wc -l`;

# No MR found, let's create a new one
if [ ${COUNTBRANCHES} -eq "0" ]; then
    curl -X POST "${HOST}${CI_PROJECT_ID}/merge_requests" \
        --header "PRIVATE-TOKEN:${GITLAB_PRIVATE_TOKEN}" \
        --header "Content-Type: application/json" \
        --data "${BODY}";

    echo "Opened a new merge request: ${COMMIT_TITLE} and assigned to you";
    exit;
fi

echo "No new merge request opened";
