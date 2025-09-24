#!/bin/bash

# Quick Datadog Tag Compliance Scan (Docker version)
# This is a simplified version that runs quickly for demos

set -e

echo "🐕 Quick Datadog Tag Compliance Check"
echo "===================================="
echo ""

# Check if we have terraform files
if [ ! -d "terraform" ]; then
    echo "❌ terraform/ directory not found"
    exit 1
fi

echo "🔍 Scanning for Datadog tag compliance issues..."
echo ""

# Run a focused scan on just our Datadog policy
checkov \
    --framework terraform \
    --directory ./terraform \
    --external-checks-dir ./policies \
    --check CKV_DD_TAGS_001 \
    --compact \
    --soft-fail

echo ""
echo "🎯 KEY TAKEAWAYS:"
echo "  • Resources without proper Datadog tags break observability"
echo "  • IaC scanning catches these issues BEFORE deployment"  
echo "  • Required tags: env, service, version, team"
echo "  • Results in better Watchdog, APM, logs, and UI experience"
echo ""
echo "✅ Scan complete!"
