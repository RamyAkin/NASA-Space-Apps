#!/bin/bash

# NASA TAP Proxy Server Startup Script
# This script starts both the Node.js proxy server and Flutter app

PROJECT_DIR="/Users/ramyakin/NASA Space Apps/exoplanet_ai"

echo "🚀 Starting NASA TAP Proxy Server and Flutter App..."

# Navigate to project directory
cd "$PROJECT_DIR"

# Check if Node.js server is already running
if lsof -i :3001 > /dev/null 2>&1; then
    echo "📡 Node.js server is already running on port 3001"
else
    echo "📡 Starting Node.js proxy server..."
    nohup node server.js > server.log 2>&1 &
    SERVER_PID=$!
    echo "📡 Node.js server started with PID: $SERVER_PID"
    
    # Wait a moment for server to start
    sleep 2
    
    # Test if server is responding
    if curl -s http://localhost:3001/health > /dev/null; then
        echo "✅ Node.js proxy server is running and responding"
    else
        echo "❌ Node.js proxy server failed to start"
        exit 1
    fi
fi

echo "🦋 Starting Flutter app..."
flutter run -d chrome

echo "👋 Flutter app stopped. Node.js server is still running in background."
echo "💡 To stop the Node.js server, run: pkill -f 'node server.js'"