FROM ubuntu:focal-20191030

RUN apt-get update \
    && apt-get install --no-install-recommends -y git jq curl ca-certificates wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O hub.tgz "https://github.com/github/hub/releases/download/v2.12.8/hub-linux-amd64-2.12.8.tgz" \
    && tar -xvf hub.tgz --strip-components 1 -C /usr/local;

LABEL "name"="dependencies"
LABEL "version"="1.0.0"

LABEL "com.github.actions.name"="Auto-commit for GitHub Actions"
LABEL "com.github.actions.description"="Auto-commits and changes back to the branch"
LABEL "com.github.actions.icon"="git"
LABEL "com.github.actions.color"="orange"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]