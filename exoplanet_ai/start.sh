#!/bin/bash
# Start script for Railway: builds Flutter web and starts the Node production server
set -e

echo "📁 Working directory: $(pwd)"

echo "🔎 Checking for Flutter..."
if command -v flutter >/dev/null 2>&1; then
  echo "✅ Flutter found: building web app..."
  flutter pub get
  flutter build web --release --web-renderer html
else
  echo "⚠️ Flutter not found on PATH. If the Railway build environment provides Flutter, it will run build steps there. Skipping local build."
fi

# Install Node dependencies (production only)
echo "📦 Installing Node.js dependencies..."
npm install --production

# Ensure production server exists
if [ ! -f production-server.js ]; then
  echo "❌ production-server.js not found. Aborting."
  exit 1
fi

# Start server
echo "🚀 Starting production server..."
node production-server.js
