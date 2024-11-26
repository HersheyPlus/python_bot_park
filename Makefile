# Color definitions
GREEN := \033[32m
YELLOW := \033[33m
RESET := \033[0m

# Variables
DOCKER := docker
IMAGE_NAME := bot
CONTAINER_NAME := bot-app

# Help text definitions
define HELP_ENV
load-env:Create virtual environment and install dependencies
endef

define HELP_DOCKER
build:Build Docker image
run:Run Docker container
stop:Stop and remove container
logs:Show container logs
shell:Open shell in container
clean:Remove container and image
endef

export HELP_ENV
export HELP_DOCKER

# Development environment setup
.PHONY: load-env
load-env:
	python3 -m venv venv
	. venv/bin/activate && pip3 install -r requirements.txt
	@echo "-> Environment loaded"
	@echo "-> Run $(GREEN)source venv/bin/activate$(RESET) to activate the environment"

# Docker commands
.PHONY: build remove run stop logs shell clean

build:
	@echo "$(YELLOW)Building Docker image...$(RESET)"
	$(DOCKER) build -t $(IMAGE_NAME) .
	@echo "$(GREEN)Build complete!$(RESET)"

remove:
	@echo "$(YELLOW)Removing Docker image...$(RESET)"
	$(DOCKER) rmi $(IMAGE_NAME) || true
	@echo "$(GREEN)Image removed!$(RESET)"

run:
	@echo "$(YELLOW)Starting container...$(RESET)"
	$(DOCKER) run -d \
		--name $(CONTAINER_NAME) \
		-v $(PWD)/logs:/bot/logs \
		-v $(PWD)/downloads:/bot/downloads \
		$(IMAGE_NAME)
	@echo "$(GREEN)Container started!$(RESET)"

stop:
	@echo "$(YELLOW)Stopping container...$(RESET)"
	$(DOCKER) stop $(CONTAINER_NAME) || true
	$(DOCKER) rm $(CONTAINER_NAME) || true
	@echo "$(GREEN)Container stopped!$(RESET)"

logs:
	@echo "$(YELLOW)Showing container logs...$(RESET)"
	$(DOCKER) logs -f $(CONTAINER_NAME)

shell:
	@echo "$(YELLOW)Opening shell in container...$(RESET)"
	$(DOCKER) exec -it $(CONTAINER_NAME) /bin/bash

clean:
	@echo "$(YELLOW)Cleaning up Docker resources...$(RESET)"
	-$(DOCKER) stop $(CONTAINER_NAME)
	-$(DOCKER) rm $(CONTAINER_NAME)
	-$(DOCKER) rmi $(IMAGE_NAME)
	@echo "$(GREEN)Cleanup complete!$(RESET)"

# Help command using loops
.PHONY: help
help:
	@echo "$(GREEN)Available commands:$(RESET)"
	@echo "  $(YELLOW)Environment:$(RESET)"
	@echo "$${HELP_ENV}" | while IFS=: read -r cmd desc; do \
		printf "    make %-10s - %s\n" "$$cmd" "$$desc"; \
	done
	@echo ""
	@echo "  $(YELLOW)Docker Commands:$(RESET)"
	@echo "$${HELP_DOCKER}" | while IFS=: read -r cmd desc; do \
		printf "    make %-10s - %s\n" "$$cmd" "$$desc"; \
	done
