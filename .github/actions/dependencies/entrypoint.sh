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

# Emit the current versions
echo "Current versions"
cat provision/pkglist

mv provision/pkglist provision/pkglist.bak
touch provision/pkglist
while read line; do
    echo "Working with ${line}"
    input=(${line//=/ })
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
title="Updated the dependencies of the docker image"
hub pull-request -m "${title}"