.DEFAULT_GOAL:=help

DOCKER_HOSTNAME=docker.io
DOCKER_PROJECT_ID=cardboardci
DOCKER_IMAGE=ci-core

DIR_BIN=bin

DOCKER_FILE=$(DOCKER_IMAGE)_$(DOCKER_TAG).tar.gz
DOCKER_LABEL=$(DOCKER_HOSTNAME)/$(DOCKER_PROJECT_ID)/$(DOCKER_IMAGE)
DOCKER_TAG=edge

##@ Build
.PHONY: build
build: ## Build an image from a Dockerfile
	docker build . \
		--file Dockerfile \
		--tag $(DOCKER_LABEL):$(DOCKER_TAG)

.PHONY: build
list: ## List one or more images stored in the image archive
	@ls $(DIR_BIN)

save: ## Save one or more images to a tar archive
	@mkdir -p $(DIR_BIN)
	@docker save $(DOCKER_LABEL):$(DOCKER_TAG) | gzip > $(DIR_BIN)/$(DOCKER_FILE)

##@ Clean
.PHONY: prune
prune: ## Remove unused data
	@docker system prune

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)