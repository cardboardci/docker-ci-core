#!/bin/bash
set -e

# Configure git
git config --global user.name '${GITHUB_ACTOR}'
git config --global user.email '${GITHUB_ACTOR}@users.noreply.github.com'

# Update package status
apt-get update

mv provision/pkglist provision/pkglist.bak
touch provision/pkglist
while read p; do
    input=(${p//=/ })
    version=$(apt-cache show ${input} | grep 'Version: ' | awk -F"[ ',]+" '/Version:/{print $2}')
    echo "${input}=${version}" >> provision/pkglist
done <provision/pkglist.bak

##
git checkout -b gh-actions/update-dependencies
git add provision/pkglist
git commit -m 'Updating the dependencies' --allow-empty
git push -u origin HEAD