# Makefile for Payroll Service

# Load environment variables from .env file
include .env
export

# Database configuration
DB_HOST ?= localhost
DB_PORT ?= 5432
DB_USER ?= postgres
DB_PASSWORD ?= postgres
DB_NAME ?= payroll_db
DB_SSLMODE ?= disable

# Migration settings
MIGRATION_DIR = modules/payroll/db/migrations
DATABASE_URL = postgres://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=$(DB_SSLMODE)

# Go settings
GO_MODULE = payroll-service
GO_CMD = go
GO_BUILD = $(GO_CMD) build
GO_RUN = $(GO_CMD) run

# Migrate binary path
MIGRATE_BIN = $(shell which migrate 2>/dev/null || echo "$(GOPATH)/bin/migrate")

.PHONY: help install-migrate db-create db-drop db-migrate-up db-migrate-down db-migrate-reset db-migrate-status db-migrate-version build run clean

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Install golang-migrate tool
install-migrate: ## Install golang-migrate tool
	@echo "Installing golang-migrate..."
	@if [ ! -f "$(GOPATH)/bin/migrate" ]; then \
		echo "Installing migrate..." && \
		go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest; \
	fi
	@echo "✅ golang-migrate installed successfully at $(GOPATH)/bin/migrate"

# Database operations
db-create: ## Create database
	@echo "Creating database $(DB_NAME)..."
	@PGPASSWORD=$(DB_PASSWORD) createdb -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) $(DB_NAME) || echo "Database may already exist"
	@echo "✅ Database $(DB_NAME) ready"

db-drop: ## Drop database
	@echo "Dropping database $(DB_NAME)..."
	@PGPASSWORD=$(DB_PASSWORD) dropdb -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) $(DB_NAME) || echo "Database may not exist"
	@echo "✅ Database $(DB_NAME) dropped"

# Migration operations
db-migrate-up: install-migrate ## Run all pending migrations
	@echo "Running migrations up..."
	@$(MIGRATE_BIN) -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" up
	@echo "✅ Migrations completed"

db-migrate-down: install-migrate ## Rollback last migration
	@echo "Rolling back last migration..."
	@$(MIGRATE_BIN) -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" down 1
	@echo "✅ Migration rolled back"

db-migrate-reset: install-migrate ## Reset database (drop all tables and re-run migrations)
	@echo "Resetting database..."
	@$(MIGRATE_BIN) -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" drop -f || true
	@$(MIGRATE_BIN) -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" up
	@echo "✅ Database reset completed"

db-migrate-status: install-migrate ## Show migration status
	@echo "Migration status:"
	@$(MIGRATE_BIN) -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" version

db-migrate-version: install-migrate ## Show current migration version
	@$(MIGRATE_BIN) -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" version

db-migrate-force: install-migrate ## Force migration to specific version (use: make db-migrate-force VERSION=1)
	@if [ -z "$(VERSION)" ]; then echo "❌ VERSION is required. Usage: make db-migrate-force VERSION=1"; exit 1; fi
	@echo "Forcing migration to version $(VERSION)..."
	@$(MIGRATE_BIN) -path $(MIGRATION_DIR) -database "$(DATABASE_URL)" force $(VERSION)
	@echo "✅ Migration forced to version $(VERSION)"

# Application operations
build: ## Build the application
	@echo "Building application..."
	@$(GO_BUILD) -o bin/payroll-service ./cmd/server
	@echo "✅ Application built successfully"

run: ## Run the application
	@echo "Starting payroll service..."
	@$(GO_RUN) ./cmd/server/main.go

dev: ## Run the application in development mode with auto-reload
	@echo "Starting payroll service in development mode..."
	@which air > /dev/null || (echo "Installing air..." && go install github.com/cosmtrek/air@latest)
	@air

# Development operations
setup: db-create db-migrate-up ## Setup development environment (create DB and run migrations)
	@echo "✅ Development environment setup completed"

clean: ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	@rm -rf bin/
	@echo "✅ Clean completed"

# Docker operations (optional)
docker-db-up: ## Start PostgreSQL using Docker
	@echo "Starting PostgreSQL container..."
	@docker run --name payroll-postgres -e POSTGRES_PASSWORD=$(DB_PASSWORD) -e POSTGRES_DB=$(DB_NAME) -p $(DB_PORT):5432 -d postgres:15-alpine || echo "Container may already exist"
	@echo "✅ PostgreSQL container started"

docker-db-down: ## Stop PostgreSQL Docker container
	@echo "Stopping PostgreSQL container..."
	@docker stop payroll-postgres || true
	@docker rm payroll-postgres || true
	@echo "✅ PostgreSQL container stopped and removed"

# Test operations
test: ## Run tests
	@echo "Running tests..."
	@$(GO_CMD) test -v ./...

test-coverage: ## Run tests with coverage
	@echo "Running tests with coverage..."
	@$(GO_CMD) test -v -coverprofile=coverage.out ./...
	@$(GO_CMD) tool cover -html=coverage.out -o coverage.html
	@echo "✅ Coverage report generated: coverage.html"

# Show database connection info
db-info: ## Show database connection information
	@echo "Database connection information:"
	@echo "  Host: $(DB_HOST)"
	@echo "  Port: $(DB_PORT)"
	@echo "  User: $(DB_USER)"
	@echo "  Database: $(DB_NAME)"
	@echo "  SSL Mode: $(DB_SSLMODE)"
	@echo "  Connection URL: $(DATABASE_URL)"