# Multi-stage Docker build for Datadog IaC Tagging Compliance Tool
FROM python:3.11-slim as base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    bash \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Python requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY policies/ ./policies/
COPY terraform/ ./terraform/
COPY scripts/ ./scripts/
COPY .yamllint.yml .
COPY .terraform-docs.yml .

# Make scripts executable
RUN chmod +x ./scripts/*.sh

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash datadog && \
    chown -R datadog:datadog /app

USER datadog

# Default command runs the Datadog tag compliance check
CMD ["./scripts/datadog-tag-check.sh"]
