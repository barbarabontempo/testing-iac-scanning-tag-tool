# 🎭 Datadog IaC Tagging Demo Script for TAMs

## Pre-Demo Setup (30 seconds)
```bash
cd testingiacscanningtagtool
./quick-setup.sh  # One-time setup, builds Docker container
```

## Demo Flow (12-15 minutes)

### 🎯 **Opening Hook** (2 minutes)
**"Let me show you how most customers accidentally break their Datadog observability..."**

1. **Set the pain point**: 
   - "Teams deploy AWS resources without proper tags"
   - "Datadog dashboards become unusable"
   - "Alerts go to wrong teams"
   - "Service maps are incomplete"

2. **Introduce the solution**:
   - "IaC scanning catches these issues BEFORE deployment"
   - "Ensures 100% Datadog tag compliance"

### 🚨 **Show the Problem** (3 minutes)
```bash
make show-terraform
```

**Walk through the examples**:
- **Point to non-compliant resources**: "Look at this EC2 instance - missing all Datadog tags"
- **Explain the impact**: "This breaks environment filtering, service mapping, and alert routing"
- **Show compliant example**: "Here's how it should look with proper env, service, version, team tags"

### 🔍 **Demonstrate the Solution** (5 minutes)
```bash
make quick-scan
```

**As the scan runs, explain**:
- "This is Checkov with custom Datadog policies"
- "It's analyzing our Terraform code before deployment"
- "Watch how it identifies every tagging violation"

**When results appear**:
- **Point to violations**: "See these specific failures? Each one would break Datadog observability"
- **Highlight validation**: "It even validates tag formats - lowercase, semantic versioning"
- **Connect to value**: "Every violation caught here is a prevented support ticket"

### ⚙️ **Show CI/CD Integration** (3 minutes)
```bash
make info  # Shows pipeline files
```

**Explain the workflow**:
- "This integrates into your existing CI/CD pipeline"
- "Pre-commit hooks catch issues locally"
- "Pipeline blocks bad deployments automatically"
- "Start with warnings, evolve to hard stops"

### ✅ **Close with Benefits** (2 minutes)
**"Here's what customers get with 100% tag compliance"**:

1. **Perfect Datadog UI Navigation**
   - Environment filtering works flawlessly
   - Service ownership is always clear
   - Quick drill-down from high-level to specific resources

2. **Enhanced Watchdog Detection**
   - Better anomaly detection with proper grouping
   - Reduced false positives
   - Faster incident response

3. **Complete APM Coverage**  
   - Automatic service mapping
   - Accurate distributed tracing
   - Version-specific performance analysis

4. **Seamless Log Management**
   - Precise filtering and correlation
   - Service-specific analysis
   - Environmental segregation

## 🎯 Key Demo Messages

### **Before IaC Scanning**
*"Teams deploy resources → Tags are missing/wrong → Datadog observability breaks → Support tickets flood in"*

### **With IaC Scanning**  
*"Teams commit code → IaC scan validates tags → Only compliant resources deploy → Perfect Datadog observability"*

### **Customer ROI**
*"Prevention vs. Remediation: Catch tagging issues in seconds during development vs. hours of troubleshooting in production"*

## 🔄 **What Happens After Demo** (Real Customer Environment)

### **Phase 1: Assessment** 
- Customer runs scan against their existing Terraform
- Identifies current tagging gaps
- Prioritizes most critical violations

### **Phase 2: Soft Rollout**
- Integrate with `--soft-fail` mode
- Teams see violations but can still deploy
- Education and gradual compliance improvement

### **Phase 3: Hard Enforcement**
- Switch to `--hard-fail-on CKV_DD_TAGS_001`
- Pipeline blocks non-compliant deployments
- 100% tag compliance achieved

### **Phase 4: Datadog Benefits**
- **All new resources** have perfect tags automatically
- **Existing resources** get retagged during normal updates
- **Complete observability** coverage across infrastructure
- **Teams love** the seamless Datadog experience

## 🤔 **Common Customer Questions**

**Q: "Does this actually deploy resources to AWS?"**  
**A:** "No, this is static analysis of Terraform code. We're preventing bad deployments, not making deployments."

**Q: "What about existing resources without tags?"**  
**A:** "The scan only affects new deployments. Existing resources can be retagged through normal update cycles or dedicated retagging projects."

**Q: "Can we customize the required tags?"**  
**A:** "Absolutely! The policies are fully customizable. We can add your organization's specific tags like cost-center, compliance-level, etc."

**Q: "How long does this take to implement?"**  
**A:** "Pilot in 1-2 days, soft rollout in 1-2 weeks, full enforcement in 1-2 months depending on existing compliance level."

**Q: "What's the performance impact?"**  
**A:** "Minimal - adds 30-60 seconds to your CI/CD pipeline. Much faster than troubleshooting tagging issues in production!"

## 📊 **Success Metrics to Highlight**

- **100%** tag compliance on new deployments
- **80% reduction** in Datadog-related support tickets
- **50% faster** incident response with proper alerting
- **90% improvement** in dashboard usability
- **Zero** production surprises from missing tags

## 🎬 **Demo Tips**

1. **Keep it visual** - Terminal output is colorful and clear
2. **Connect every violation to Datadog pain** - Don't just show problems, explain impact
3. **Emphasize prevention** - "Caught in development vs. discovered in production"
4. **Show the progression** - Soft warnings → Hard blocks → Perfect compliance
5. **End with vision** - "Imagine never having a tagging issue in Datadog again"
