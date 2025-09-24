#!/bin/bash

# Datadog IaC Tagging Compliance Demo Runner
# This script provides an interactive demo for customers

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
cat << 'EOF'
  ____        _            _             ___        ____    ____                         
 |  _ \  __ _| |_ __ _  __| | ___   __ _ |_ _|__    / ___|  |  _ \  ___ _ __ ___   ___    
 | | | |/ _` | __/ _` |/ _` |/ _ \ / _` | | |/ _ \  | |     | | | |/ _ \ '_ ` _ \ / _ \   
 | |_| | (_| | || (_| | (_| | (_) | (_| | | | (_) | | |___  | |_| |  __/ | | | | | (_) |  
 |____/ \__,_|\__\__,_|\__,_|\___/ \__, ||___\___/   \____| |____/ \___|_| |_| |_|\___/   
                                  |___/                                                  

🐕 Datadog IaC Tagging Compliance Tool
    Zero-friction customer demonstration
EOF
echo -e "${NC}"

echo ""
echo -e "${CYAN}🎯 This demo shows how IaC scanning prevents Datadog tagging issues BEFORE deployment${NC}"
echo ""

# Function to pause for demo pacing
demo_pause() {
    echo -e "${YELLOW}[Press Enter to continue...]${NC}"
    read
}

# Function to run a demo step
run_demo_step() {
    local step_title="$1"
    local command="$2"
    local description="$3"
    
    echo -e "\n${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📋 STEP: ${step_title}${NC}"
    echo -e "${YELLOW}💡 ${description}${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    demo_pause
    
    echo -e "${GREEN}🚀 Running: ${command}${NC}"
    echo ""
    eval "$command"
}

# Demo Step 1: Show the problem
run_demo_step \
    "Show Non-Compliant Infrastructure" \
    "echo 'Let me show you some typical Terraform resources...' && cat terraform/main.tf | grep -A 10 -B 5 'NON-COMPLIANT'" \
    "These resources are missing Datadog tags, which breaks observability"

# Demo Step 2: Run the scan
run_demo_step \
    "Run IaC Scan with Datadog Policies" \
    "./scripts/datadog-tag-check.sh" \
    "Our custom Checkov policies detect Datadog tagging violations"

# Demo Step 3: Show compliant examples
run_demo_step \
    "Show Compliant Resource Examples" \
    "echo 'Now let me show you properly tagged resources...' && cat terraform/main.tf | grep -A 15 -B 2 'DATADOG COMPLIANT'" \
    "These resources have all required Datadog tags for full observability"

# Demo Step 4: Show specific violations
run_demo_step \
    "Analyze Specific Violations" \
    "checkov --framework terraform --directory ./terraform --external-checks-dir ./policies --check CKV_DD_TAGS_001 --compact" \
    "Focus on just our Datadog tagging policy to see specific failures"

# Demo Step 5: Show CI/CD integration
run_demo_step \
    "Show CI/CD Integration" \
    "echo 'Here\\'s how this integrates into your pipeline...' && cat .github/workflows/iac-scanning.yml | head -50" \
    "This workflow runs automatically on every pull request and deployment"

echo ""
echo -e "${GREEN}🎉 DEMO COMPLETE!${NC}"
echo ""
echo -e "${BLUE}📊 WHAT CUSTOMERS GET:${NC}"
echo -e "  ✅ 100% Datadog tagging compliance"
echo -e "  🔍 Automatic violation detection"
echo -e "  🚫 Prevents bad deployments"
echo -e "  📈 Better Datadog observability"
echo -e "  🤖 Enhanced Watchdog detection"
echo -e "  🎯 Seamless UI navigation"
echo ""
echo -e "${YELLOW}🎯 NEXT STEPS FOR CUSTOMER:${NC}"
echo -e "  1. Install Checkov in their environment"
echo -e "  2. Customize policies for their tags"
echo -e "  3. Integrate into CI/CD pipeline"
echo -e "  4. Start with soft-fail, move to hard-fail"
echo -e "  5. Enjoy perfect Datadog observability!"
echo ""
echo -e "${CYAN}📞 Questions? Contact your Datadog TAM!${NC}"
