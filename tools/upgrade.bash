#!/bin/bash
set -e

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