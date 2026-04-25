# Update: 2026-04-26
# Maintainer: Daniel Lin

SHELL          := /bin/bash
.DEFAULT_GOAL  := help

# ==============================================================================
# Color Definitions
# ==============================================================================
RED      := $(shell tput -Txterm setaf 1)
GREEN    := $(shell tput -Txterm setaf 2)
YELLOW   := $(shell tput -Txterm setaf 3)
BLUE     := $(shell tput -Txterm setaf 4)
MAGENTA  := $(shell tput -Txterm setaf 5)
CYAN     := $(shell tput -Txterm setaf 6)
WHITE    := $(shell tput -Txterm setaf 7)
RESET    := $(shell tput -Txterm sgr0)

# ==============================================================================
# Path and Environment Configuration
# ==============================================================================
MKFILE_PATH      := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR         := $(shell dirname $(MKFILE_PATH))
WORK_DIR         := $(CURDIR)
ZSHRC            := ${HOME}/.zshrc
CLOUDSDK_CONFIG  := config/gcloud
LOWER_ARCH       := $(shell uname -m)

# ==============================================================================
# Platform and Container Settings
# ==============================================================================
PLATFORMS        ?= linux/amd64 linux/arm64
MAP_PLATFORMS    ?= amd64 arm64
CONTAINER_NAME   := dracula
DOCKERHUB_ACCOUNT ?= zarr12steven

# ==============================================================================
# Tool Versions (April 2026 Latest)
# ==============================================================================
ANSIBLE_VERSION               ?= 2.20.5
DOCKER_VERSION                ?= 29.4.1
DOCKER_COMPOSE_VERSION        ?= 5.1.2
BUILDX_VERSION                ?= 0.33.0
AWSCLIv2_VERSION              ?= 2.34.32
AZ_VERSION                    ?= 2.85.0
GCPCLI_VERSION                ?= 565.0.0-0
DOCKER_CREDENTIAL_GCR_VERSION ?= 2.1.32
TF_VERSION                    ?= 1.14.9
TERRAGRUNT_VERSION            ?= 1.0.2
KUBECTL_VERSION               ?= 1.36.0
KREW_VERSION                  ?= 0.5.0
KUSTOMIZE_VERSION             ?= 5.8.1
HELM_VERSION                  ?= 4.1.4
TEKTON_VERSION                ?= 0.44.1
GOLANG_VERSION                ?= 1.26.2
K9S_VERSION                   ?= 0.50.18
LOKI_VERSION                  ?= 3.7.1
YQ_VERSION                    ?= 4.53.2
GUM_VERSION                   ?= 0.17.0
INFRACOST_VERSION             ?= 0.10.44

# ==============================================================================
# Build Arguments and Macros
# ==============================================================================
BUILD_ARGS := \
    --build-arg buildtime_ANSIBLE_VERSION=$(ANSIBLE_VERSION) \
    --build-arg buildtime_DOCKER_VERSION=$(DOCKER_VERSION) \
    --build-arg buildtime_DOCKER_COMPOSE_VERSION=$(DOCKER_COMPOSE_VERSION) \
    --build-arg buildtime_BUILDX_VERSION=$(BUILDX_VERSION) \
    --build-arg buildtime_AWSCLIv2_VERSION=$(AWSCLIv2_VERSION) \
    --build-arg buildtime_AZ_VERSION=$(AZ_VERSION) \
    --build-arg buildtime_GCPCLI_VERSION=$(GCPCLI_VERSION) \
    --build-arg buildtime_DOCKER_CREDENTIAL_GCR_VERSION=$(DOCKER_CREDENTIAL_GCR_VERSION) \
    --build-arg buildtime_TF_VERSION=$(TF_VERSION) \
    --build-arg buildtime_TERRAGRUNT_VERSION=$(TERRAGRUNT_VERSION) \
    --build-arg buildtime_KUBECTL_VERSION=$(KUBECTL_VERSION) \
    --build-arg buildtime_KREW_VERSION=$(KREW_VERSION) \
    --build-arg buildtime_KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) \
    --build-arg buildtime_HELM_VERSION=$(HELM_VERSION) \
    --build-arg buildtime_TEKTON_VERSION=$(TEKTON_VERSION) \
    --build-arg buildtime_GOLANG_VERSION=$(GOLANG_VERSION) \
    --build-arg buildtime_K9S_VERSION=$(K9S_VERSION) \
    --build-arg buildtime_LOKI_VERSION=$(LOKI_VERSION) \
    --build-arg buildtime_YQ_VERSION=$(YQ_VERSION) \
    --build-arg buildtime_GUM_VERSION=$(GUM_VERSION) \
    --build-arg buildtime_INFRACOST_VERSION=$(INFRACOST_VERSION)

define SHOW_VERSIONS
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "ANSIBLE_VERSION" "$(ANSIBLE_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "DOCKER_VERSION" "$(DOCKER_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "DOCKER_COMPOSE_VERSION" "$(DOCKER_COMPOSE_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "BUILDX_VERSION" "$(BUILDX_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "AWSCLIv2_VERSION" "$(AWSCLIv2_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "AZ_VERSION" "$(AZ_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "GCPCLI_VERSION" "$(GCPCLI_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "GCR_CREDENTIAL_VERSION" "$(DOCKER_CREDENTIAL_GCR_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "TF_VERSION" "$(TF_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "TERRAGRUNT_VERSION" "$(TERRAGRUNT_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "KUBECTL_VERSION" "$(KUBECTL_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "KREW_VERSION" "$(KREW_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "KUSTOMIZE_VERSION" "$(KUSTOMIZE_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "HELM_VERSION" "$(HELM_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "TEKTON_VERSION" "$(TEKTON_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "GOLANG_VERSION" "$(GOLANG_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "K9S_VERSION" "$(K9S_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "LOKI_VERSION" "$(LOKI_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "YQ_VERSION" "$(YQ_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "GUM_VERSION" "$(GUM_VERSION)"; \
	printf "${YELLOW}%-30s = ${MAGENTA}%s${RESET}\n" "INFRACOST_VERSION" "$(INFRACOST_VERSION)";
endef

define running_platform
	printf "${YELLOW}########################################################################################################################${RESET}\n"; \
	printf "${YELLOW}%-2sRunning Platform${RESET} ${CYAN}$${PLATFORM}${RESET}\n"; \
	printf "${YELLOW}%-2sMap Platform    ${RESET} ${CYAN}$${MAP_PLATFORM}${RESET}\n"; \
	printf "${YELLOW}%-2sContainer Image ${RESET} ${CYAN}$(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME}-$${MAP_PLATFORM}${RESET}\n"; \
	$(SHOW_VERSIONS) \
	printf "${YELLOW}########################################################################################################################${RESET}\n"; \
	docker run --name ${CONTAINER_NAME}-$${MAP_PLATFORM} \
		--volume "$(CURDIR):/work/terraform" \
		--volume "/work/terraform/dracula" \
		--volume "$(CURDIR)/../tekton:/work/tekton" \
		--volume "$(CURDIR)/../ansible:/work/ansible" \
		--volume "$(CURDIR)/../gke:/work/gke" \
		--volume "$${HOME}/.azure:/root/.azure" \
		--volume "$${HOME}/.config/gcloud:/root/.config/gcloud" \
		--volume "$${HOME}/.ssh:/root/.ssh" \
		--volume "$${HOME}/.tmux.conf:/root/.tmux.conf" \
		--volume "$${HOME}/.tmux:/root/.tmux" \
		--privileged -it $(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME}-$${MAP_PLATFORM} bash
endef

##@ Docker Management

.PHONY: show
show: ## Show current running container
	@docker container ls -a

.PHONY: build
build: ## Build docker images (using context from dracula/)
	@platforms_list="$(PLATFORMS)"; \
	map_list="$(MAP_PLATFORMS)"; \
	platforms_array=($$platforms_list); \
	map_array=($$map_list); \
	for i in $$(seq 0 $$(( $$(echo $$platforms_list | wc -w) - 1 ))); do \
		platform=$${platforms_array[$$i]}; \
		map_platform=$${map_array[$$i]}; \
		printf "${YELLOW}########################################################################################################################${RESET}\n"; \
		printf "${YELLOW}%-2sBuilding Platform${RESET} ${CYAN}$${platform}${RESET}\n"; \
		$(SHOW_VERSIONS) \
		printf "${YELLOW}########################################################################################################################${RESET}\n"; \
		docker buildx build --platform=$${platform} \
			--build-arg TARGETPLATFORM=$${platform} \
			$(BUILD_ARGS) \
			-t $(DOCKERHUB_ACCOUNT)/${CONTAINER_NAME}-$${map_platform} -f dracula/Dockerfile dracula/; \
	done

.PHONY: run
run: ## Start running container (interactive menu)
	@if [ ! -d "$(WORK_DIR)/$(CLOUDSDK_CONFIG)" ]; then \
		mkdir -p $(WORK_DIR)/$(CLOUDSDK_CONFIG); \
	fi; \
	echo "Please choose a platform:"; \
	platforms_list="$(PLATFORMS) Quit"; \
	map_list="$(MAP_PLATFORMS)"; \
	platforms_array=($$platforms_list); \
	map_array=($$map_list); \
	select choice in $$platforms_list; do \
		if [ "$$choice" = "Quit" ]; then \
			echo "Exiting..."; \
			break; \
		elif [ -n "$$choice" ]; then \
			for i in $$(seq 0 $$(( $$(echo $$platforms_list | wc -w) - 2 ))); do \
				if [ "$$choice" = "$${platforms_array[$$i]}" ]; then \
					PLATFORM="$${platforms_array[$$i]}"; \
					MAP_PLATFORM="$${map_array[$$i]}"; \
					$(call running_platform,$$PLATFORM,$$MAP_PLATFORM); \
					break 2; \
				fi; \
			done; \
		else \
			echo "${RED}[ERROR]${RESET} Invalid choice."; \
		fi; \
	done

.PHONY: attach
attach: ## Attach to the running container
	@arch_suffix=$$( [ "$(LOWER_ARCH)" = "x86_64" ] && echo "amd64" || echo "arm64" ); \
	CONTAINER_STATUS=$$(docker ps -a --filter "name=$(CONTAINER_NAME)-$$arch_suffix" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "running" ]; then \
		printf "[INFO] Container ${CYAN}$(CONTAINER_NAME)-$$arch_suffix${RESET} is ${GREEN}running${RESET}.\n"; \
	fi; \
	docker exec -it $(CONTAINER_NAME)-$$arch_suffix bash

.PHONY: reattach
reattach: ## Restart and reattach to the existing container
	@arch_suffix=$$( [ "$(LOWER_ARCH)" = "x86_64" ] && echo "amd64" || echo "arm64" ); \
	CONTAINER_STATUS=$$(docker ps -a --filter "name=$(CONTAINER_NAME)-$$arch_suffix" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "exited" ]; then \
		printf "${MAGENTA}[WARNING]${RESET} Container ${CYAN}$(CONTAINER_NAME)-$$arch_suffix${RESET} is ${MAGENTA}exited${RESET}. ${YELLOW}Restarting...${RESET}\n"; \
		docker start $(CONTAINER_NAME)-$$arch_suffix >> /dev/null; \
	fi; \
	printf "[INFO] Container ${CYAN}$(CONTAINER_NAME)-$$arch_suffix${RESET} is ${GREEN}running${RESET}.\n"; \
	docker exec -it $(CONTAINER_NAME)-$$arch_suffix bash

.PHONY: halt
halt: ## Stop the running container
	@arch_suffix=$$( [ "$(LOWER_ARCH)" = "x86_64" ] && echo "amd64" || echo "arm64" ); \
	CONTAINER_STATUS=$$(docker ps -a --filter "name=$(CONTAINER_NAME)-$$arch_suffix" --format "{{.State}}"); \
	if [ "$${CONTAINER_STATUS}" = "running" ]; then \
		printf "[INFO] Stopping Container ${CYAN}$(CONTAINER_NAME)-$$arch_suffix${RESET}.\n"; \
		docker stop $(CONTAINER_NAME)-$$arch_suffix >> /dev/null; \
		printf "[INFO] Container ${CYAN}$(CONTAINER_NAME)-$$arch_suffix${RESET} is ${GREEN}exited${RESET}.\n"; \
	fi

.PHONY: remove
remove: ## Stop and remove the container
	@arch_suffix=$$( [ "$(LOWER_ARCH)" = "x86_64" ] && echo "amd64" || echo "arm64" ); \
	CONTAINER_ID=$$(docker ps -aq --filter "name=^/$(CONTAINER_NAME)-$$arch_suffix$$"); \
	if [ -n "$${CONTAINER_ID}" ]; then \
		printf "[INFO] Force Removing Container ${CYAN}$(CONTAINER_NAME)-$$arch_suffix${RESET}.\n"; \
		docker rm -f $(CONTAINER_NAME)-$$arch_suffix > /dev/null 2>&1; \
		printf "[INFO] Container ${CYAN}$(CONTAINER_NAME)-$$arch_suffix${RESET} is ${GREEN}removed${RESET}.\n"; \
	else \
		printf "[INFO] Container ${CYAN}$(CONTAINER_NAME)-$$arch_suffix${RESET} does not exist.\n"; \
	fi

.PHONY: clean
clean: ## Garbage disposal (dangling images/exited containers)
	@echo "${YELLOW}[Docker]${RESET} Cleaning up..."
	@images=$$(docker images -q -f dangling=true); \
	if [ -n "$$images" ]; then docker rmi -f $$images; fi; \
	containers=$$(docker ps -qa -f status=exited); \
	if [ -n "$$containers" ]; then docker rm -f $$containers; fi

##@ Terraform Operations

.PHONY: init
init: ## Initialize terraform
	@echo "${GREEN}[Terraform]${RESET} Initializing..."
	@terraform init

.PHONY: plan
plan: ## Show execution plan
	@echo "${GREEN}[Terraform]${RESET} Planning..."
	@terraform plan -var-file=terraform.tfvars

.PHONY: apply
apply: ## Apply changes (auto-approve)
	@echo "${GREEN}[Terraform]${RESET} Applying..."
	@terraform apply -var-file=terraform.tfvars -auto-approve

.PHONY: fmt
fmt: ## Format files recursively
	@echo "${YELLOW}[Terraform]${RESET} Formatting files..."
	@terraform fmt -recursive

.PHONY: validate
validate: ## Validate syntax
	@echo "${CYAN}[Terraform]${RESET} Validating..."
	@terraform validate

##@ Help

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\n${YELLOW}Usage:${RESET}\n  make ${CYAN}<target>${RESET}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${CYAN}%-15s${RESET} %s\n", $$1, $$2 } /^##@/ { printf "\n${YELLOW}%s${RESET}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
