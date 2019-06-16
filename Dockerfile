FROM ubuntu:disco

COPY provision/pkglist /cardboardci/pkglist
RUN apt-get update && apt-get upgrade -y \
    && xargs -a /cardboardci/pkglist apt-get install --no-install-recommends -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ci
RUN groupadd -r cardboardci && useradd --no-log-init -r -g cardboardci cardboardci
USER cardboardci

##
## Image Metadata
##
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
    org.label-schema.url = "https://gitlab.com/cardboardci/images/ci-core" \
    org.label-schema.changelog-url = "https://gitlab.com/cardboardci/images/ci-core/releases" \
    org.label-schema.authoritative-source-url = "https://cloud.docker.com/u/cardboardci/repository/docker/cardboardci/ci-core" \
    org.label-schema.distribution-scope = "public" \
    org.label-schema.vcs-type = "git" \
    org.label-schema.vcs-url = "https://gitlab.com/cardboardci/images/ci-core" \
    org.label-schema.vcs-ref = "${vcs_ref}" \