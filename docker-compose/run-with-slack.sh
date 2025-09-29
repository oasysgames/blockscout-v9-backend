#!/bin/bash

# Script to run BlockScout with Slack webhook configuration
# This script isolates sensitive environment variables from the repository

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Error: .env file not found!"
    echo "Please create a .env file with your Slack webhook URL:"
    echo ""
    echo "cat > .env << 'EOF'"
    echo "SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"
    echo "SLACK_CHANNEL=#alert-oasys"
    echo "SLACK_USERNAME=Error Scanner"
    echo "SLACK_ICON_EMOJI=:warning:"
    echo "EOF"
    echo ""
    exit 1
fi

# Load environment variables
source .env

# Check required variables
if [ -z "$SLACK_WEBHOOK_URL" ]; then
    echo "Error: SLACK_WEBHOOK_URL not set in .env file!"
    exit 1
fi

echo "Starting BlockScout with error-scanner and Slack alerts..."
echo "Slack Channel: ${SLACK_CHANNEL:-#alert-oasys}"

# Run docker compose with environment variables
FRONT_PROXY_PASS=http://host.docker.internal:3000/ \
BACK_PROXY_PASS=http://backend:4000 \
docker compose -f external-frontend.yml up -d

echo "Services started! Check Slack channel for error alerts."
echo "To view logs: docker compose -f external-frontend.yml logs error-scanner -f"
