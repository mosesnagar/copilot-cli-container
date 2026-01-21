.PHONY: build run run-clone shell clean help

IMAGE_NAME := copilot-cli-container
PROJECT ?= .

# Detect container runtime
RUNTIME := $(shell command -v docker 2>/dev/null || command -v podman 2>/dev/null)

help:
	@echo "Copilot CLI Container - Makefile Commands"
	@echo ""
	@echo "Usage:"
	@echo "  make build                    Build the container image"
	@echo "  make run PROJECT=/path        Run with project mounted"
	@echo "  make run-clone REPO=owner/repo Clone and run"
	@echo "  make shell PROJECT=/path      Start a shell in container"
	@echo "  make clean                    Remove the container image"
	@echo ""
	@echo "Examples:"
	@echo "  make build"
	@echo "  make run PROJECT=~/my-project"
	@echo "  make run PROJECT=~/my-project YOLO=1"
	@echo "  make run-clone REPO=facebook/react"

build:
	$(RUNTIME) build -t $(IMAGE_NAME) .

run:
	./copilot-container --mount $(PROJECT) $(if $(YOLO),--yolo)

run-clone:
ifndef REPO
	$(error REPO is required. Usage: make run-clone REPO=owner/repo)
endif
	./copilot-container --clone $(REPO) $(if $(YOLO),--yolo)

shell:
	./copilot-container --mount $(PROJECT) --shell

clean:
	$(RUNTIME) rmi $(IMAGE_NAME) 2>/dev/null || true

# Docker Compose shortcuts
compose-build:
	$(RUNTIME) compose build

compose-up:
	$(RUNTIME) compose run --rm copilot
