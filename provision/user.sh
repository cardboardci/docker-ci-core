#!/bin/sh
set -e

groupadd -r cardboardci && useradd --no-log-init -r -g cardboardci cardboardci