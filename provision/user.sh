#!/bin/sh
set -e

groupadd -r cardboardci 
useradd --password "" --no-log-init -r -g cardboardci cardboardci
adduser cardboardci sudo

mkdir -p /home/cardboardci
chown cardboardci /home/cardboardci