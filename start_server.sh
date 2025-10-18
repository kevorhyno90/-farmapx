#!/bin/bash

# Stable server script for animal management system
# This script will restart the server automatically if it crashes

cd /workspaces/-farmapx/build/web

echo "Starting stable animal management system server..."

while true; do
    echo "$(date): Starting HTTP server on port 8080..."
    python3 -m http.server 8080 --bind 0.0.0.0
    
    echo "$(date): Server stopped. Restarting in 5 seconds..."
    sleep 5
done