FROM ubuntu:focal-20191129
ARG DEBIAN_FRONTEND=noninteractive
ARG USER

#
# Upgrade to latest of ubuntu
#
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

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
USER ${USER}
WORKDIR /cardboardci/workspace
ENTRYPOINT [ "/bin/bash" ]

#
# Image Metadata
#
ARG version=1.0.0
LABEL maintainer="CardboardCI"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="ci-core"
LABEL org.label-schema.version="${version}"
LABEL org.label-schema.release="CardboardCI version:${version}"
LABEL org.label-schema.vendor="cardboardci"
LABEL org.label-schema.architecture="amd64"
LABEL org.label-schema.summary="Base image for CI"
LABEL org.label-schema.description="Base image for CI."
LABEL org.label-schema.url="https://github.com/cardboardci/docker-ci-core"
LABEL org.label-schema.changelog-url="https://github.com/cardboardci/docker-ci-core/releases"
LABEL org.label-schema.authoritative-source-url="https://hub.docker.com/r/cardboardci/ci-core"
LABEL org.label-schema.distribution-scope="public"
LABEL org.label-schema.vcs-type="git"
LABEL org.label-schema.vcs-url="https://github.com/cardboardci/docker-ci-core"