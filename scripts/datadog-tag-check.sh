#!/bin/bash

# Datadog Tag Compliance Checker Script
# This script runs Checkov with Datadog-specific policies and provides a compliance summary

set -e

echo "🐕 DATADOG TAG COMPLIANCE CHECKER"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if checkov is installed
if ! command -v checkov &> /dev/null; then
    echo -e "${RED}❌ Checkov is not installed. Please install it with: pip install checkov${NC}"
    exit 1
fi

# Check if terraform directory exists
if [ ! -d "terraform" ]; then
    echo -e "${RED}❌ terraform/ directory not found${NC}"
    exit 1
fi

# Check if policies directory exists
if [ ! -d "policies" ]; then
    echo -e "${RED}❌ policies/ directory not found${NC}"
    exit 1
fi

echo -e "${BLUE}🔍 Running Checkov scan with Datadog tag policies...${NC}"
echo ""

# Create temporary files for results
TEMP_RESULTS=$(mktemp)
TEMP_JSON=$(mktemp)

# Run Checkov with our custom policies
checkov \
    --framework terraform \
    --directory ./terraform \
    --external-checks-dir ./policies \
    --output cli \
    --output json \
    --output-file-path "$TEMP_RESULTS","$TEMP_JSON" \
    --soft-fail \
    --quiet || true

echo ""
echo -e "${BLUE}📊 SCAN RESULTS SUMMARY${NC}"
echo "======================="

# Parse JSON results for detailed analysis
if [ -f "$TEMP_JSON" ]; then
    python3 << EOF
import json
import sys

try:
    with open('$TEMP_JSON', 'r') as f:
        results = json.load(f)
    
    total_checks = len(results.get('results', {}).get('passed_checks', [])) + len(results.get('results', {}).get('failed_checks', []))
    passed_checks = len(results.get('results', {}).get('passed_checks', []))
    failed_checks = len(results.get('results', {}).get('failed_checks', []))
    
    # Count Datadog-specific violations
    datadog_violations = 0
    datadog_resources = []
    
    for check in results.get('results', {}).get('failed_checks', []):
        if check.get('check_id', '').startswith('CKV_DD') or 'datadog' in check.get('check_name', '').lower():
            datadog_violations += 1
            datadog_resources.append({
                'resource': check.get('resource', 'Unknown'),
                'file': check.get('file_path', 'Unknown'),
                'check': check.get('check_name', 'Unknown')
            })
    
    print(f"✅ Total checks run: {total_checks}")
    print(f"✅ Passed checks: {passed_checks}")
    print(f"❌ Failed checks: {failed_checks}")
    print(f"🏷️  Datadog tag violations: {datadog_violations}")
    print("")
    
    if datadog_violations > 0:
        print("🚨 DATADOG TAG COMPLIANCE ISSUES:")
        print("-" * 40)
        
        seen_resources = set()
        for resource in datadog_resources[:10]:  # Show first 10
            resource_key = f"{resource['resource']}:{resource['file']}"
            if resource_key not in seen_resources:
                print(f"  📄 {resource['file']}")
                print(f"     Resource: {resource['resource']}")
                print(f"     Issue: {resource['check']}")
                print("")
                seen_resources.add(resource_key)
        
        if len(datadog_resources) > 10:
            print(f"  ... and {len(datadog_resources) - 10} more violations")
        
        print("")
        print("💡 REQUIRED DATADOG TAGS:")
        print("  • env: Environment (prod, staging, dev, test)")
        print("  • service: Service name (lowercase-with-hyphens)")
        print("  • version: Version (semantic versioning or branch)")
        print("  • team: Owning team (lowercase-with-hyphens)")
        print("")
        print("🎯 WHY THESE TAGS MATTER:")
        print("  • Enable seamless Datadog UI navigation")
        print("  • Improve Watchdog anomaly detection")
        print("  • Enhance APM service mapping")
        print("  • Better log correlation and filtering")
        print("  • Effective RUM and K8s monitoring")
        
    else:
        print("🎉 EXCELLENT! All resources are Datadog tag compliant!")
        print("   Your infrastructure is optimized for Datadog observability.")
    
except Exception as e:
    print(f"Error parsing results: {e}")
    sys.exit(1)
EOF

else
    echo -e "${YELLOW}⚠️ No JSON results file generated${NC}"
fi

# Display the CLI results
if [ -f "$TEMP_RESULTS" ]; then
    echo ""
    echo -e "${BLUE}📋 DETAILED RESULTS${NC}"
    echo "=================="
    cat "$TEMP_RESULTS"
fi

# Cleanup
rm -f "$TEMP_RESULTS" "$TEMP_JSON"

echo ""
echo -e "${GREEN}🏁 Datadog tag compliance check completed!${NC}"

# Return appropriate exit code
if [ -f "$TEMP_JSON" ]; then
    python3 << EOF
import json
import sys

try:
    with open('$TEMP_JSON', 'r') as f:
        results = json.load(f)
    
    datadog_violations = 0
    for check in results.get('results', {}).get('failed_checks', []):
        if check.get('check_id', '').startswith('CKV_DD'):
            datadog_violations += 1
    
    if datadog_violations > 0:
        print("⚠️  Found Datadog tag violations - please review and fix.")
        # Exit with 0 for soft-fail behavior, change to sys.exit(1) for hard-fail
        sys.exit(0)
    else:
        sys.exit(0)
        
except:
    sys.exit(0)
EOF
fi
