#!/bin/bash
set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

# Configure git
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git config --global http.sslverify false

# Update package status
apt-get update

mv provision/pkglist provision/pkglist.bak
touch provision/pkglist
while read p; do
    echo "Working with ${p}"
    input=(${p//=/ })
    echo "Determining version for ${input}"
    version=$(apt-cache show ${input} | grep 'Version: ' | awk -F"[ ',]+" '/Version:/{print $2}')
    echo "Found version as ${version}"
    echo "${input}=${version}" >> provision/pkglist
done <provision/pkglist.bak

##
cat provision/pkglist

## Commit changes
branch_name="gh-actions/update-dependencies-$(shuf -i 2000-65000 -n 1)"
git checkout -b "${branch_name}"
git add provision/pkglist
git commit -m 'Updating the dependencies' --allow-empty

## Add authenticated remote
git remote add github "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git push -u github HEAD

## Create a pull request
URI=https://api.github.com
REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")
DEFAULT_BRANCH=$(jq -r ".repository.default_branch" "$GITHUB_EVENT_PATH")
PULLS_URI="${URI}/repos/$REPO_FULLNAME/pulls"
API_HEADER="Accept: application/vnd.github.shadow-cat-preview"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"

title="Updated the dependencies of the docker image"
resp=$(curl --data "{\"title\":\"$title\", \"head\": \"$branch_name\", \"draft\": true, \"base\": \"$DEFAULT_BRANCH\"}" -X POST -s -H "${AUTH_HEADER}" -H "${API_HEADER}" ${PULLS_URI})

echo "$resp"