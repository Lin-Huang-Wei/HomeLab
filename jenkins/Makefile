SHELL := /bin/bash

.DEFAULT_GOAL := help

##################################################
# Setup output color
##################################################

RED                    := $(shell tput -Txterm setaf 1)
GREEN                  := $(shell tput -Txterm setaf 2)
YELLOW                 := $(shell tput -Txterm setaf 3)
BLUE                   := $(shell tput -Txterm setaf 4)
MAGENTA                := $(shell tput -Txterm setaf 5)
CYAN                   := $(shell tput -Txterm setaf 6)
WHITE                  := $(shell tput -Txterm setaf 7)
RESET                  := $(shell tput -Txterm sgr0)

##################################################
# Set global variables
##################################################

MKFILE_PATH            := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR               := $(shell dirname $(MKFILE_PATH))
DOCKERFILE             := ${ROOT_DIR}/Dockerfile
CONTAINER_NAME         := jenkins
CONTAINER_TAG          := latest
CONTAINER_RUNNING      := $(shell docker container ls -q -f name=${CONTAINER} -f status="running")
EMPTY                  :=

#################################################
# Set default variables values, if the variable have be setting, will be replaced.
# https://pypi.org/project/ansible/
# https://github.com/ansible/ansible/tags
#################################################

ifndef ANSIBLE_VERSION
    override ANSIBLE_VERSION=7.2.0
endif

#################################################
# Set default variables values, if the variable have be setting, will be replaced.
# https://github.com/docker/compose/releases
#################################################

ifndef DOCKER_COMPOSE_VERSION
    override DOCKER_COMPOSE_VERSION=2.16.0
endif

#################################################
# Set default variables values, if the variable have be setting, will be replaced.
#################################################

ifndef JENKINS_USER
   override JENKINS_USER := $(if $(EMPTY), ${JENKINS_USER}, admin)
endif

ifndef JENKINS_PASS
    override JENKINS_PASS := $(if $(EMPTY), ${JENKINS_PASS}, admin)
endif

##################################################
# Get ansible and docker-compose latest tag from github
##################################################

#ANSIBLE_LATEST=$(shell curl -s "https://api.github.com/repos/ansible/ansible/tags" | grep 'name' | sed -E 's/.*"([^"]+)".*/\1/' | head -n 1 | cut -c 2-)
DOCKDER_COMPOSE_LATEST=$(shell curl -s "https://api.github.com/repos/docker/compose/tags" | grep 'name' | sed -E 's/.*"([^"]+)".*/\1/' | grep -Ev '^v1.*|^docs-.*|-test$|-rc?' | head -n 1 | cut -c 2-)

##@ Docker

.PHONY: show
show: ## Show current running container
	@docker container ls

.PHONY: build
build: ## Build Jenkins Image, defaults ANSIBLE_VERSION=7.2.0, JAVA_USE_MEMORY=2048m
	@if [ -f "${DOCKERFILE}" ]; then cd ${shell pwd} && \
		time docker build --build-arg buildtime_JENKINS_USER=$(JENKINS_USER) \
		--build-arg buildtime_JENKINS_PASS=$(JENKINS_PASS) \
		--build-arg buildtime_ANSIBLE_VERSION=$(ANSIBLE_VERSION) \
		--build-arg buildtime_DOCKER_COMPOSE_VERSION=$(DOCKER_COMPOSE_VERSION) \
		-t ${CONTAINER_NAME}:${CONTAINER_TAG} -f ${DOCKERFILE} .; fi
	@echo "Current Jenkins Administrator Account: " $(JENKINS_USER)
	@echo "Current Jenkins Administrator PASSWORD: " $(JENKINS_PASS)


.PHONY: run
run: ## Start container, when exiting the container will be gone.
	@if [ -z "${CONTAINER_RUNNING}" ]; then mkdir -p $(shell pwd)/ansible $(shell pwd)/var/jenkins_home $(shell pwd)/var/log/jenkins && \
	echo "docker run -d --name ${CONTAINER_NAME} -p 10022:22 -p 8081:8080 -p 50000:50000 -p 50001:50001 --restart="on-failure" \
	--env JENKINS_USER=${JENKINS_USER} \
	--env JENKINS_PASS=${JENKINS_PASS} \
	--volume "$(shell pwd)/ansible:/work/ansible" \
	--volume "$(shell pwd)/var/jenkins_home:/var/jenkins_home" \
	--volume "$(shell pwd)/var/log/jenkins:/var/log/jenkins" \
	-it ${CONTAINER_NAME}:${CONTAINER_TAG}"; \
	fi
	@if [ -z "${CONTAINER_RUNNING}" ]; then mkdir -p $(shell pwd)/ansible $(shell pwd)/var/jenkins_home $(shell pwd)/var/log/jenkins && \
	docker run -d --name ${CONTAINER_NAME} -p 10022:22 -p 8081:8080 -p 50000:50000 -p 50001:50001 --restart="on-failure" \
	--env JENKINS_USER=${JENKINS_USER} \
	--env JENKINS_PASS=${JENKINS_PASS} \
	--volume "$(shell pwd)/ansible:/work/ansible" \
	--volume "$(shell pwd)/var/jenkins_home:/var/jenkins_home" \
	--volume "$(shell pwd)/var/log/jenkins:/var/log/jenkins" \
	-it ${CONTAINER_NAME}:${CONTAINER_TAG}; \
	fi


.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make ${BLUE}<target>${RESET}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n${YELLOW}%s${RESET}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
