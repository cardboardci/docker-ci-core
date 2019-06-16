#!/usr/bin/env bats

BATS_VERSION=0.4.0

load "${BATS_HELPERS_DIR}/bats-support/load.bash"
load "${BATS_HELPERS_DIR}/bats-file/load.bash"
load "${BATS_HELPERS_DIR}/bats-assert/load.bash"

run_command_with_docker() {
  docker run --rm -t ${CUSTOM_DOCKER_RUN_OPTS} \
    "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}" "$@"
}

setup() {
  export CUSTOM_DOCKER_RUN_OPTS=""
}

@test "Base OS is using Alpine Linux" {
  local CUSTOM_DOCKER_RUN_OPTS="--entrypoint grep"
  run_command_with_docker "Alpine" /etc/os-release
}

@test "Bash is installed" {
  local CUSTOM_DOCKER_RUN_OPTS="--entrypoint which"
	run_command_with_docker bash
}