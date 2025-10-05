#!/bin/bash

# NASA Exoplanet Web App - Production Deployment Script
# This script builds and deploys the complete web application

set -e  # Exit on any error

PROJECT_DIR="/Users/ramyakin/NASA Space Apps/exoplanet_ai"
PORT=${PORT:-8080}

echo "🚀 NASA Exoplanet Web App - Production Deployment"
echo "=================================================="

# Navigate to project directory
cd "$PROJECT_DIR"

echo ""
echo "📦 Installing dependencies..."
echo "------------------------------"

# Install Flutter dependencies
echo "Installing Flutter dependencies..."
flutter pub get

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
npm install

echo ""
echo "🔨 Building Flutter Web App..."
echo "-------------------------------"

# Clean previous build
flutter clean

# Build Flutter web app for production
flutter build web --release --web-renderer html

echo ""
echo "✅ Build completed successfully!"
echo ""

# Copy production package.json
cp package-production.json package.json

echo "🎯 Production server configuration:"
echo "   - Port: $PORT"
echo "   - Flutter web app: http://localhost:$PORT"
echo "   - API endpoints available at: http://localhost:$PORT/api/*"
echo ""

echo "🚦 Starting production server..."
echo "--------------------------------"

# Kill any existing processes on the port
if lsof -i :$PORT > /dev/null 2>&1; then
    echo "⚠️  Port $PORT is in use. Attempting to free it..."
    pkill -f "node.*production-server.js" || true
    sleep 2
fi

# Start production server
echo "Starting production server on port $PORT..."
node production-server.js

echo ""
echo "🎉 Deployment completed!"
echo "Access your web app at: http://localhost:$PORT"