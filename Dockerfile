FROM ubuntu:focal-20191030
ARG DEBIAN_FRONTEND=noninteractive

#
# Upgrade to latest of ubuntu
#
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

#
# Install dependencies
#
COPY provision/pkglist /cardboardci/pkglist
RUN apt-get update \
    && xargs -a /cardboardci/pkglist apt-get install --no-install-recommends -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY provision/user.sh /cardboardci/user.sh
RUN bash /cardboardci/user.sh ; sync ; rm -f /cardboardci/user.sh

#
# Set the image properties
#
USER cardboardci
WORKDIR /cardboardci/workspace
ENTRYPOINT [ "/bin/bash" ]

#
# Image Metadata
#
ARG build_date
ARG version
ARG vcs_ref
LABEL maintainer = "CardboardCI" \
    \
    org.label-schema.schema-version = "1.0" \
    \
    org.label-schema.name = "ci-core" \
    org.label-schema.version = "${version}" \
    org.label-schema.build-date = "${build_date}" \
    org.label-schema.release= = "CardboardCI version:${version} build-date:${build_date}" \
    org.label-schema.vendor = "cardboardci" \
    org.label-schema.architecture = "amd64" \
    \
    org.label-schema.summary = "Base image for CI" \
    org.label-schema.description = "Base image for CI." \
    \
    org.label-schema.url = "https://github.com/cardboardci/docker-ci-core" \
    org.label-schema.changelog-url = "https://github.com/cardboardci/docker-ci-core/releases" \
    org.label-schema.authoritative-source-url = "https://hub.docker.com/r/cardboardci/ci-core" \
    org.label-schema.distribution-scope = "public" \
    org.label-schema.vcs-type = "git" \
    org.label-schema.vcs-url = "https://github.com/cardboardci/docker-ci-core" \
    org.label-schema.vcs-ref = "${vcs_ref}" \