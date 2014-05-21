#!/bin/sh
#
# usage: add-github-webhooks.sh OWNER REPO URL CHANNEL
# for example:
#   add-github-webhooks.sh wking dockerfile http://irc.example.net:80 '#dockerfile'

# Create a token with https://github.com/settings/tokens/new
#
# The token needs write:repo_hook [1].
#
# [1]: https://developer.github.com/v3/oauth/
TOKEN="FIXME"

if test -z "${TOKEN}" || test 'xFIXME' = "x${TOKEN}"
then
	echo "edit $0 and set TOKEN to a GitHub authentication token" >&2
	exit 1
fi

OWNER="$1"
REPO="$2"
URL="$3"
CHANNEL="$4"

ENDPOINT="https://api.github.com"


# https://developer.github.com/v3/repos/hooks/#create-a-hook
curl --request POST \
	--header "Authorization: token ${TOKEN}" \
	--header "Content-Type: application/json" \
	--data @- \
	"${ENDPOINT}/repos/${OWNER}/${REPO}/hooks" <<EOF
{
	"name": "web",
	"config": {
		"url": "${URL}/hubot/gh-commits?room=${CHANNEL}",
		"content_type": "json",
		"insecure_ssl": false
		},
	"events": ["push"],
	"active": true
}
EOF

curl --request POST \
	--header "Authorization: token ${TOKEN}" \
	--header "Content-Type: application/json" \
	--data @- \
	"${ENDPOINT}/repos/${OWNER}/${REPO}/hooks" <<EOF
{
	"name": "web",
	"config": {
		"url": "${URL}/hubot/gh-pull-requests?room=${CHANNEL}",
		"content_type": "json",
		"insecure_ssl": false
		},
	"events": ["pull_request"],
	"active": true
}
EOF
