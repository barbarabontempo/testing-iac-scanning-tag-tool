# Makefile for Datadog IaC Tagging Compliance Tool
# Simplifies Docker operations for customer demos

.PHONY: help build demo quick-scan shell clean validate lint

# Default target
help: ## Show this help message
	@echo "🐕 Datadog IaC Tagging Compliance Tool"
	@echo "===================================="
	@echo ""
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"; printf "\033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo ""
	@echo "💡 Quick start: make demo"

##@ 🚀 Demo Commands

demo: build ## Run interactive customer demonstration
	@echo "🎭 Starting interactive Datadog tagging compliance demo..."
	@docker compose run --rm datadog-iac-scanner ./scripts/demo-runner.sh

quick-scan: build ## Run quick compliance scan
	@echo "⚡ Running quick Datadog tag compliance scan..."
	@docker compose run --rm datadog-iac-scanner ./scripts/quick-scan.sh

scan-json: build ## Run scan with JSON output for analysis
	@echo "📊 Running scan with JSON output..."
	@mkdir -p results
	@docker compose run --rm -v $(PWD)/results:/app/results datadog-iac-scanner \
		checkov --framework terraform --directory ./terraform --external-checks-dir ./policies \
		--output json --output-file-path /app/results/scan-results.json --soft-fail
	@echo "✅ Results saved to results/scan-results.json"

##@ 🛠️ Development Commands

build: ## Build Docker image
	@echo "🏗️ Building Datadog IaC scanner Docker image..."
	@docker compose build datadog-iac-scanner

shell: build ## Access interactive shell in container
	@echo "🐚 Starting interactive shell..."
	@docker compose run --rm datadog-iac-scanner bash

validate: build ## Validate Terraform configuration
	@echo "✅ Validating Terraform configuration..."
	@docker compose run --rm terraform-validator terraform validate

##@ 📋 Testing Commands  

test-policies: build ## Test custom Checkov policies
	@echo "🧪 Testing custom Datadog tagging policies..."
	@docker compose run --rm datadog-iac-scanner \
		checkov --framework terraform --directory ./terraform --external-checks-dir ./policies \
		--check CKV_DD_TAGS_001 --output cli --soft-fail

lint: build ## Lint policy files
	@echo "🔍 Linting Python policy files..."
	@docker compose run --rm datadog-iac-scanner \
		/bin/bash -c "cd policies && python -m flake8 . --max-line-length=120"

##@ 🧹 Cleanup Commands

clean: ## Clean up Docker resources
	@echo "🧹 Cleaning up Docker resources..."
	@docker compose down --rmi local --volumes --remove-orphans
	@docker system prune -f

clean-results: ## Clean up scan results
	@echo "🗑️ Cleaning up scan results..."
	@rm -rf results/
	@mkdir -p results

##@ 📚 Information Commands

info: ## Show project information
	@echo "🐕 Datadog IaC Tagging Compliance Tool"
	@echo "===================================="
	@echo ""
	@echo "📋 This tool demonstrates IaC scanning for Datadog tag compliance"
	@echo "🎯 Required tags: env, service, version, team"
	@echo "🔍 Uses Checkov with custom policies"
	@echo "🚀 Perfect for TAM customer demonstrations"
	@echo ""
	@echo "📁 Project structure:"
	@find . -type f -name "*.py" -o -name "*.tf" -o -name "*.yml" -o -name "*.yaml" | \
		grep -v __pycache__ | sort
	@echo ""
	@echo "🔗 For more info, see README.md"

logs: ## Show recent container logs
	@echo "📄 Recent container logs..."
	@docker compose logs --tail=50

##@ 🎬 Customer Demo Scenarios

demo-violations: build ## Show only resources with violations
	@echo "🚨 Showing resources with Datadog tag violations..."
	@docker compose run --rm datadog-iac-scanner \
		checkov --framework terraform --directory ./terraform --external-checks-dir ./policies \
		--check CKV_DD_TAGS_001 --output cli --compact | grep -A 5 -B 5 "FAILED\|CKV_DD"

demo-compliant: build ## Show only compliant resources  
	@echo "✅ Showing compliant resources..."
	@docker compose run --rm datadog-iac-scanner \
		checkov --framework terraform --directory ./terraform --external-checks-dir ./policies \
		--check CKV_DD_TAGS_001 --output cli --compact | grep -A 5 -B 5 "PASSED"

show-terraform: ## Display Terraform examples
	@echo "📄 Terraform resource examples:"
	@echo ""
	@echo "🚨 Non-compliant resources:"
	@grep -A 8 -B 2 "NON-COMPLIANT" terraform/main.tf || true
	@echo ""
	@echo "✅ Compliant resources:"  
	@grep -A 8 -B 2 "DATADOG COMPLIANT" terraform/main.tf || true
