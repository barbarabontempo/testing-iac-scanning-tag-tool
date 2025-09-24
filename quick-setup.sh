#!/bin/bash

# Datadog IaC Tagging Compliance Tool - Quick Setup
# Run this script to immediately start the customer demo

set -e

echo "🐕 Datadog IaC Tagging Compliance Tool"
echo "Quick Setup for TAM Customer Demos"
echo "===================================="
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not running"
    echo "   Please install Docker Desktop and try again"
    echo "   https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not available"
    echo "   Please install Docker Compose and try again"
    exit 1
fi

echo "✅ Docker environment ready"
echo ""

# Check if make is available (optional but recommended)
if command -v make &> /dev/null; then
    echo "✅ Make is available - you can use 'make demo' commands"
    USE_MAKE=true
else
    echo "⚠️  Make is not available - will use docker-compose directly"
    USE_MAKE=false
fi

echo ""
echo "🏗️ Building Datadog IaC scanner container..."
echo ""

# Build the container
if [ "$USE_MAKE" = true ]; then
    make build
else
    docker compose build datadog-iac-scanner
fi

echo ""
echo "🎉 Setup complete! You can now run:"
echo ""

if [ "$USE_MAKE" = true ]; then
    echo "📋 Available commands:"
    echo "  make demo              # Interactive customer demonstration"
    echo "  make quick-scan        # Fast compliance check"  
    echo "  make show-terraform    # Show resource examples"
    echo "  make demo-violations   # Show only violations"
    echo "  make shell             # Explore the container"
    echo "  make help              # See all commands"
else
    echo "📋 Available commands:"
    echo "  docker compose run datadog-iac-scanner ./scripts/demo-runner.sh"
    echo "  docker compose run datadog-iac-scanner ./scripts/quick-scan.sh"
    echo "  docker compose run datadog-iac-scanner bash"
fi

echo ""
echo "🚀 Ready for customer demonstrations!"
echo ""

# Ask if they want to run the demo immediately
read -p "🎭 Would you like to run the interactive demo now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🎬 Starting interactive customer demo..."
    if [ "$USE_MAKE" = true ]; then
        make demo
    else
        docker compose run --rm datadog-iac-scanner ./scripts/demo-runner.sh
    fi
else
    echo ""
    echo "👍 Demo ready to run when needed!"
    if [ "$USE_MAKE" = true ]; then
        echo "   Run 'make demo' to start the interactive demonstration"
    else
        echo "   Run 'docker compose run datadog-iac-scanner ./scripts/demo-runner.sh'"
    fi
fi
