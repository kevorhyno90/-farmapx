#!/bin/bash

# Keepalive script to prevent Codespace restarts
# This script performs lightweight operations to keep the Codespace active

echo "Starting Codespace keepalive script..."

while true; do
    # Light system check every 5 minutes
    echo "$(date): Keepalive ping - Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}'), Disk: $(df -h /workspaces | awk 'NR==2 {print $3 "/" $2}')"
    
    # Sleep for 5 minutes (300 seconds)
    sleep 300
done