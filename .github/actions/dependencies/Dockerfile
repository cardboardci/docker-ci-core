FROM ubuntu:focal-20191030

RUN apt-get update \
    && apt-get install --no-install-recommends -y git jq curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL "name"="dependencies"
LABEL "version"="1.0.0"

LABEL "com.github.actions.name"="Auto-commit for GitHub Actions"
LABEL "com.github.actions.description"="Auto-commits and changes back to the branch"
LABEL "com.github.actions.icon"="git"
LABEL "com.github.actions.color"="orange"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]