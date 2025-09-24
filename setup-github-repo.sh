#!/bin/bash

# GitHub Repository Setup Script for Datadog IaC Tagging Tool
# Run this script to create and configure your GitHub repository

set -e

echo "🐕 GitHub Setup for Datadog IaC Tagging Compliance Tool"
echo "====================================================="
echo ""

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

# Get GitHub username
echo "📝 Setting up GitHub repository..."
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ GitHub username is required"
    exit 1
fi

# Set repository name
REPO_NAME="datadog-iac-tagging-tool"
read -p "Repository name (default: $REPO_NAME): " INPUT_REPO_NAME
if [ ! -z "$INPUT_REPO_NAME" ]; then
    REPO_NAME="$INPUT_REPO_NAME"
fi

echo ""
echo "📋 Repository Details:"
echo "  Username: $GITHUB_USERNAME"
echo "  Repository: $REPO_NAME"
echo "  URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "🔧 Initializing Git repository..."
    git init
    git branch -M main
else
    echo "✅ Git repository already initialized"
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "📝 Creating .gitignore..."
    cat << 'EOF' > .gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
venv/
env/
ENV/

# Terraform
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
terraform.tfvars
terraform.tfvars.json
*.tfvars
*.tfvars.json

# Docker
.dockerignore

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Results
results/
*.log

# Disabled policies
*.disabled
EOF
else
    echo "✅ .gitignore already exists"
fi

# Add all files
echo "📦 Adding files to git..."
git add .

# Commit files
echo "💾 Creating initial commit..."
git commit -m "🐕 Add Datadog IaC tagging compliance tool

Features:
- Custom Checkov policies for Datadog tags (env, service, version, team)
- Docker-based scanning for easy deployment
- GitHub Actions CI/CD integration
- Interactive customer demo scripts
- Complete TAM demo workflow

Perfect for showcasing proactive IaC scanning to prevent Datadog observability issues."

echo ""
echo "🚀 NEXT STEPS:"
echo ""
echo "1. Create repository on GitHub:"
echo "   https://github.com/new"
echo "   Repository name: $REPO_NAME"
echo "   Make it public or private as needed"
echo ""
echo "2. Push to GitHub:"
echo "   git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo "   git push -u origin main"
echo ""
echo "3. GitHub Actions will automatically:"
echo "   ✅ Run on every push and PR"
echo "   📊 Scan for Datadog tag violations"
echo "   💬 Comment on PRs with results"
echo "   🔒 Show in Security tab"
echo ""
echo "4. View results at:"
echo "   https://github.com/$GITHUB_USERNAME/$REPO_NAME/actions"
echo ""
echo "🎯 Your repository will demonstrate:"
echo "  • Automated Datadog tag compliance checking"
echo "  • Prevention of deployment with missing/invalid tags"
echo "  • Complete observability readiness"
echo ""
echo "Perfect for customer demos! 🎭"
