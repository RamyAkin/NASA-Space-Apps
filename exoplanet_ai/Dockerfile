# Use Node.js 18 Alpine as base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package-production.json package.json
COPY package-lock.json* ./

# Install Node.js dependencies
RUN npm ci --only=production

# Copy the built Flutter web app
COPY build/web ./build/web

# Copy server files
COPY production-server.js ./
COPY model_stats.json* ./

# Create directory for logs
RUN mkdir -p logs

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/api/stats || exit 1

# Start production server
CMD ["node", "production-server.js"]