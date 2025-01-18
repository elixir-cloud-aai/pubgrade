IMAGE_NAME_PUBGRADE=elixircloud/pubgrade
IMAGE_NAME_UPDATER=elixircloud/pubgrade-updater
APP_NAME=pubgrade



.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


build: ## Builds two container images (main-service, build-complete-updater).
	docker build -t $(IMAGE_NAME_PUBGRADE) .
	docker build -f build-complete-updater/Dockerfile -t $(IMAGE_NAME_UPDATER) .

test: ## Runs unit tests and shows coverage.
	coverage run --source pubgrade -m pytest
	coverage report -m

install-pubgrade: # build ## Install pubgrade on cluster using helm.
#	kubectl create namespace $(APP_NAME) --dry-run=client -o yaml | kubectl apply -f -
	helm upgrade --install $(APP_NAME) deployment/ -n $(APP_NAME)

uninstall-pubgrade: ## Uninstall pubgrade.
	helm delete $(APP_NAME) -n $(APP_NAME)
	kubectl delete namespace $(APP_NAME)
