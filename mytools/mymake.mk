.PHONY: help test test-all test-cover clean-testcache \
        build run fmt vet dev

CHECK_GOMOD := $(shell test -f go.mod || (echo "❌ Not in Go module root (missing go.mod)" && exit 1))
HAS_AIR := $(shell command -v air >/dev/null 2>&1 && echo yes || echo no)

## Print all available commands
help:
	@echo ""
	@echo "Available make commands:"
	@echo "  make test            - Run tests in ./tests directory (no cache)"
	@echo "  make test-all        - Run all tests (no cache)"
	@echo "  make test-cover      - Run all tests with coverage output"
	@echo "  make clean-testcache - Clean test cache"
	@echo "  make build           - Build Go project (go build)"
	@echo "  make run             - Run Go project (go run main.go)"
	@echo "  make fmt             - Format Go code (go fmt)"
	@echo "  make vet             - Analyze code with go vet"
	@echo "  make dev             - Start development server with Air hot-reload"
	@echo ""

test:
	@$(CHECK_GOMOD)
	go test -v -count=1 ./tests

test-all:
	@$(CHECK_GOMOD)
	go test -v -count=1 ./...

test-cover:
	@$(CHECK_GOMOD)
	go test -v -count=1 -cover ./...

clean-testcache:
	go clean -testcache

build:
	@$(CHECK_GOMOD)
	go build -o goblog2

run:
	@$(CHECK_GOMOD)
	go run main.go

fmt:
	go fmt ./...

vet:
	go vet ./...

dev:
ifeq ($(HAS_AIR),yes)
	@echo "✅ Starting development server with Air..."
	air
else
	@echo "❌ Air not found. Install with:"
	@echo "   go install github.com/air-verse/air@latest"
endif
