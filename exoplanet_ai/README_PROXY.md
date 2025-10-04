# NASA Exoplanet Archive CORS Proxy

This directory contains a simple Python Flask server that acts as a CORS proxy for the NASA Exoplanet Archive TAP service.

## Setup and Usage

### 1. Install Dependencies

```bash
cd '/Users/ramyakin/NASA Space Apps/exoplanet_ai'
python3 -m pip install -r requirements.txt
```

### 2. Start the Node.js Proxy Server

```bash
cd '/Users/ramyakin/NASA Space Apps/exoplanet_ai'
npm install
node server.js
```

The server will start on `http://localhost:3001` and print:
```
🚀 NASA TAP CORS proxy server started
📡 Server running at: http://localhost:3001
💚 Health check: http://localhost:3001/health
🔗 TAP endpoint: http://localhost:3001/tap/sync
```

### 3. Run the Flutter App

In a new terminal, start the Flutter app:

```bash
cd '/Users/ramyakin/NASA Space Apps/exoplanet_ai'
flutter run -d chrome
```

## How It Works

1. **Problem**: The NASA TAP service doesn't include CORS headers, so web browsers block direct requests from Flutter web apps.

2. **Solution**: The Python proxy server:
   - Receives requests at `http://localhost:5000/tap/sync`
   - Forwards them to `https://exoplanetarchive.ipac.caltech.edu/TAP/sync`
   - Returns the response with proper CORS headers

3. **Flutter Integration**: The `ExoplanetService` now uses `http://localhost:5000/tap/sync` instead of the direct NASA endpoint.

## Endpoints

- `GET /health` - Health check (returns JSON status)
- `GET /tap/sync?query=...&format=json` - Proxy to NASA TAP service

## Testing

Test the proxy directly:
```bash
curl "http://localhost:5000/tap/sync?query=SELECT%20top%205%20*%20FROM%20ps&format=json"
```

## Production Deployment

For production, consider:
- Using a proper WSGI server (gunicorn, uWSGI)
- Adding authentication/rate limiting
- Hosting the proxy on your application server
- Or using a cloud function/serverless approach