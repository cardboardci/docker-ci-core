#!/bin/bash
set -e

# Configure git
git config --global user.name '${GITHUB_ACTOR}'
git config --global user.email '${GITHUB_ACTOR}@users.noreply.github.com'
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
git checkout -b gh-actions/update-dependencies
git add provision/pkglist
git commit -m 'Updating the dependencies' --allow-empty
git push -u origin HEAD
# git remote add github "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
# git push -u github HEAD