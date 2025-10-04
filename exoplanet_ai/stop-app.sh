#!/bin/bash

# Stop all running processes for the NASA TAP project

echo "🛑 Stopping NASA TAP Proxy Server and related processes..."

# Kill Node.js server
if pgrep -f "node server.js" > /dev/null; then
    echo "📡 Stopping Node.js proxy server..."
    pkill -f "node server.js"
    echo "✅ Node.js proxy server stopped"
else
    echo "📡 Node.js proxy server was not running"
fi

# Kill Flutter processes
if pgrep -f "flutter run" > /dev/null; then
    echo "🦋 Stopping Flutter app..."
    pkill -f "flutter run"
    echo "✅ Flutter app stopped"
else
    echo "🦋 Flutter app was not running"
fi

# Kill any processes using port 3001
if lsof -ti:3001 > /dev/null 2>&1; then
    echo "🔌 Freeing port 3001..."
    lsof -ti:3001 | xargs kill -9
    echo "✅ Port 3001 freed"
fi

echo "🧹 All processes stopped and ports freed"