# Multi-stage Dockerfile: build Flutter web with Flutter SDK, then serve with Node.js

# 1) Builder: Flutter SDK image to build web
FROM cirrusci/flutter:stable AS builder

WORKDIR /app

# Copy the whole repo so we can access exoplanet_ai
COPY . .

# Build the Flutter web app located in exoplanet_ai
RUN cd exoplanet_ai \
    && flutter pub get \
    && flutter build web --release --web-renderer html

# 2) Runtime: Node.js lightweight image to serve static files and run API
FROM node:18-alpine

WORKDIR /app

# Copy built web artifacts from builder
COPY --from=builder /app/exoplanet_ai/build/web ./build/web

# Copy production server and package files
COPY exoplanet_ai/production-server.js ./production-server.js
COPY exoplanet_ai/package.json ./package.json

# Install production Node.js dependencies
RUN npm ci --only=production

# Expose port
EXPOSE 8080

# Start server
CMD ["node", "production-server.js"]
