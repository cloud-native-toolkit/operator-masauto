#!/usr/bin/env bash

##
## This checks unread notifications for a release of a repository.
## If a release is found for that repo, then an issue is opened in 
## a specified repository.  That notification is then marked as read
## so it isn't processed again.
##
## Requires: 
##   - an access token is required that has access to read notifications
##     and access to create an issue.
##   - the account the access token belongs to, must subscribe to notifications 
##     from the repository it is watching
## 

# repo string in format: "{org}/{repo}" to check for releases
REPO_NAME="$1"

# get the notifications for the repo
resp=$(curl -H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer ${NOTIFICATION_TOKEN} " \
https://api.github.com/notifications)

# for each notification check if it's a release notification for the repo we care about
for row in $(echo "${resp}" | jq -r '.[] | @base64'); do
    type=$(echo ${row} | base64 -d | jq -r '.subject.type' )
    repo=$(echo ${row} | base64 -d | jq -r '.repository.full_name' )

    if [[ $type == "Release" ]] && [[ $repo == ${REPO_NAME} ]]; then

        title=$(echo ${row} | base64 -d | jq -r '.subject.title' )
        threadid=$(echo ${row} | base64 -d | jq -r '.id' )

# for release notificaitons, build the data for the issue to open
        _issue_data()
        {
            cat << EOF
{
    "title": "New $repo Release: $title",
    "body": "New Release $title created in $repo",
    "labels": [
        "enhancement",
        "new release"
    ]
}
EOF
        }

# create the issue and mark notification as read
        curl -X "POST" "https://api.github.com/repos/tcskill/mas-issue-automation/issues" \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${NOTIFICATION_TOKEN}" \
        -d "$(_issue_data)"

        curl -X PATCH \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${NOTIFICATION_TOKEN}" \
        https://api.github.com/notifications/threads/${threadid}

    fi
done
