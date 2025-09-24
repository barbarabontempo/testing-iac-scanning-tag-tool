"""
Custom Checkov policy to enforce Datadog-specific required tags on AWS resources
This policy ensures all resources have the mandatory tags for Datadog observability
and seamless navigation in Datadog UI, Watchdog, APM, Logs, RUM, and K8s monitoring
"""

from checkov.common.models.enums import Severities, CheckCategories
from checkov.terraform.checks.resource.base_resource_check import BaseResourceCheck


class DatadogTagsCheck(BaseResourceCheck):
    def __init__(self):
        # Define the required Datadog tags that must be present on all resources
        self.required_tags = [
            "env",
            "service", 
            "version",
            "team"
        ]
        
        # Define valid values for env tag (environments)
        self.valid_environments = [
            "prod",
            "production",
            "staging", 
            "stage",
            "dev",
            "development",
            "test",
            "qa"
        ]
        
        # Define validation patterns for other tags
        self.service_pattern = r"^[a-z0-9-]+$"  # lowercase with hyphens
        self.version_pattern = r"^(v?\d+\.\d+\.\d+|latest|main|develop)$"  # semantic version or branch
        self.team_pattern = r"^[a-z0-9-]+$"  # lowercase team names
        
        name = "Ensure all AWS resources have required Datadog tags (env, service, version, team)"
        id = "CKV_DD_TAGS_001"
        supported_resources = [
            "aws_instance",
            "aws_s3_bucket", 
            "aws_rds_instance",
            "aws_security_group",
            "aws_vpc",
            "aws_subnet",
            "aws_lb",
            "aws_alb",
            "aws_nlb",
            "aws_ecs_cluster",
            "aws_ecs_service",
            "aws_eks_cluster",
            "aws_lambda_function",
            "aws_dynamodb_table",
            "aws_sqs_queue",
            "aws_sns_topic"
        ]
        categories = [CheckCategories.GENERAL_SECURITY]
        super().__init__(name=name, id=id, categories=categories, supported_resources=supported_resources)

    def scan_resource_conf(self, conf):
        """
        Validates Datadog-specific tags on terraform resources
        Ensures env, service, version, and team tags are present with valid values
        :param conf: terraform resource configuration
        :return: <CheckResult>
        """
        import re
        
        # Check if tags exist
        if 'tags' not in conf:
            self.details = f"🚨 DATADOG TAGGING VIOLATION: Resource is missing all tags. Required Datadog tags: {', '.join(self.required_tags)}"
            return CheckCategories.FAILED  # Changed to FAILED for proper violation detection

        tags = conf['tags'][0] if isinstance(conf['tags'], list) else conf['tags']
        
        violations = []
        
        # Check for required Datadog tags
        missing_tags = []
        for required_tag in self.required_tags:
            if required_tag not in tags:
                missing_tags.append(required_tag)
        
        if missing_tags:
            violations.append(f"Missing required Datadog tags: {', '.join(missing_tags)}")
        
        # Validate 'env' tag
        if "env" in tags:
            env_value = str(tags["env"])
            if isinstance(tags["env"], list):
                env_value = str(tags["env"][0])
            
            if env_value not in self.valid_environments:
                violations.append(f"Invalid 'env' tag value '{env_value}'. Valid values: {', '.join(self.valid_environments)}")
        
        # Validate 'service' tag format
        if "service" in tags:
            service_value = str(tags["service"])
            if isinstance(tags["service"], list):
                service_value = str(tags["service"][0])
                
            if not re.match(self.service_pattern, service_value):
                violations.append(f"Invalid 'service' tag format '{service_value}'. Must be lowercase letters, numbers, and hyphens only")
        
        # Validate 'version' tag format
        if "version" in tags:
            version_value = str(tags["version"])
            if isinstance(tags["version"], list):
                version_value = str(tags["version"][0])
                
            if not re.match(self.version_pattern, version_value):
                violations.append(f"Invalid 'version' tag format '{version_value}'. Must be semantic version (1.2.3), 'latest', 'main', or 'develop'")
        
        # Validate 'team' tag format
        if "team" in tags:
            team_value = str(tags["team"])
            if isinstance(tags["team"], list):
                team_value = str(tags["team"][0])
                
            if not re.match(self.team_pattern, team_value):
                violations.append(f"Invalid 'team' tag format '{team_value}'. Must be lowercase letters, numbers, and hyphens only")
        
        if violations:
            self.details = f"🚨 DATADOG TAGGING VIOLATIONS: {'; '.join(violations)}"
            return CheckCategories.FAILED
        
        self.details = "✅ All required Datadog tags are present and valid for seamless Datadog monitoring"
        return CheckCategories.PASSED


# Create the check instance
check = DatadogTagsCheck()

