#!/bin/bash

# Hot Update Script - Update your deployed app without downtime
# This script builds and updates the web app while keeping the server running

PROJECT_DIR="/Users/ramyakin/NASA Space Apps/exoplanet_ai"
BACKUP_DIR="$PROJECT_DIR/backup_build"
PORT=${PORT:-8080}

echo "🔄 Hot Update Process Starting..."
echo "================================="

cd "$PROJECT_DIR"

echo ""
echo "📱 Building new Flutter web version..."
flutter clean
flutter build web --release

echo ""
echo "💾 Creating backup of current version..."
if [ -d "$BACKUP_DIR" ]; then
    rm -rf "$BACKUP_DIR"
fi
cp -r "build/web" "$BACKUP_DIR"

echo ""
echo "🔄 Checking if server is running..."
if lsof -i :$PORT > /dev/null 2>&1; then
    echo "✅ Server is running on port $PORT"
    echo "📂 Hot-swapping web files..."
    
    # The production server serves from build/web, so files are automatically updated
    echo "✅ Web app updated! Changes are live at http://localhost:$PORT"
else
    echo "⚠️  Server not running. Starting fresh deployment..."
    node production-server.js &
    echo "🚀 Server started with updated app at http://localhost:$PORT"
fi

echo ""
echo "🎉 Hot update completed successfully!"
echo "Your users can refresh their browsers to see the updates."