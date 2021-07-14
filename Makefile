ifndef APP_ENV
	# Determine if .env file exist
	ifneq ("$(wildcard .env.build)","")
		include .env.build
	endif
endif

DOCKER_EXEC=docker-compose exec --user www-data
APP_CONTAINER=workspace

ifeq ($(strip $(BUILD_ENV)),dev)
	DOCKER_COMPOSE_SERVICES=nginx mariadb workspace
	DOCKER_COMPOSE_FILE=-f docker-compose-dev.yml
else
	DOCKER_COMPOSE_SERVICES=nginx mariadb workspace
	DOCKER_COMPOSE_FILE=-f docker-compose.yml
endif

DOCKER_COMPOSE := docker-compose $(DOCKER_COMPOSE_FILE)
DOCKER_EXEC=$(DOCKER_COMPOSE) exec --user www-data
DOCKER_EXEC_ROOT=$(DOCKER_COMPOSE) exec --user root

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-27s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ [Docker] Build / Infrastructure
.PHONY: docker-compose
docker-compose: ## Run docker compose command. For command use c=<command>
	$(DOCKER_COMPOSE) $(c)

.PHONY: ps
ps: ## Show all containers
	$(DOCKER_COMPOSE) ps

.PHONY: exec
exec: ## Exec command inside workspace container. For command use c=<command>
	$(DOCKER_EXEC) $(APP_CONTAINER) $(c)

.PHONY: build
build: ## Build docker environment
	$(DOCKER_COMPOSE) build $(DOCKER_COMPOSE_SERVICES)

.PHONY: start
start: ## Start docker-compose services
	$(DOCKER_COMPOSE) up -d $(DOCKER_COMPOSE_SERVICES)

.PHONY: stop
stop: ## Stop docker-compose services
	$(DOCKER_COMPOSE) down

.PHONY: restart
restart: ## Restart docker-compose services
	$(DOCKER_COMPOSE) restart

.PHONY: build-services
build-services: ## Build docker environment with specified services. For command use s=<services>
	$(DOCKER_COMPOSE) build $(s)

.PHONY: start-services
start-services: ## Start specified docker-compose services. For command use s=<services>
	$(DOCKER_COMPOSE) up -d $(s)

.PHONY: stop-services
stop-services: ## Stop specified docker-compose services. For command use s=<services>
	$(DOCKER_COMPOSE) down $(s)

.PHONY: restart-services
restart-services: ## Restart specified docker-compose services. For command use s=<services>
	$(DOCKER_COMPOSE) restart $(s)

.PHONY: build-services-no-cache
build-services-no-cache: ## Build docker environment with specified services and without cache. For command use s=<services>
	$(DOCKER_COMPOSE) build --no-cache $(s)

.PHONY: bash
bash: ## exec app container
	$(DOCKER_EXEC) $(APP_CONTAINER) bash

##@ [Laravel] Laravel commands
.PHONY: artisan
artisan: ## php artisan. c=<command>
	$(DOCKER_EXEC) $(APP_CONTAINER) php artisan $(c)

.PHONY: tinker
tinker: ## php artisan tinker
	$(DOCKER_EXEC_ROOT) $(APP_CONTAINER) php artisan tinker

##@ [Laravel] Laravel Ide Helper
.PHONY: ide-helper
ide-helper: ## php artisan ide-helper:generate
	$(DOCKER_EXEC) $(APP_CONTAINER) php artisan ide-helper:generate

.PHONY: ide-helper-model
ide-helper-model: ## php artisan ide-helper:models. m=<model> ex. m='App\\Data\\Models\\User'
	$(DOCKER_EXEC) $(APP_CONTAINER) php artisan ide-helper:models $(m)
