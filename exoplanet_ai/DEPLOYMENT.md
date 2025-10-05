# NASA Exoplanet Discovery Web App - Deployment Guide

A complete web application for exoplanet discovery and analysis, built with Flutter Web frontend and Node.js backend.

## 🚀 Quick Start

### Option 1: Simple Deployment (Recommended)

```bash
# Make sure you're in the project directory
cd "/Users/ramyakin/NASA Space Apps/exoplanet_ai"

# Run the deployment script
./deploy-production.sh
```

This will:
- Install all dependencies
- Build the Flutter web app
- Start the production server on port 8080
- Make your app available at http://localhost:8080

### Option 2: Manual Deployment

```bash
# 1. Install dependencies
flutter pub get
npm install

# 2. Build Flutter web app
flutter build web --release

# 3. Start production server
cp package-production.json package.json
node production-server.js
```

### Option 3: Docker Deployment

```bash
# Build the Docker image
docker build -t nasa-exoplanet-app .

# Run the container
docker run -p 8080:8080 nasa-exoplanet-app
```

## 🌐 What You Get

Your web app will be accessible at `http://localhost:8080` with the following features:

### Frontend (Flutter Web)
- **Interactive Exoplanet Explorer**: Navigate through different categories
- **Real-time Data**: Fetches live data from NASA Exoplanet Archive
- **Machine Learning Integration**: Predict exoplanet habitability
- **Responsive Design**: Works on desktop, tablet, and mobile

### Backend API Endpoints
- `GET /` - Serves the Flutter web app
- `GET /tap/sync` - NASA TAP service proxy
- `POST /predict` - Machine learning predictions
- `GET /api/stats` - Model statistics and usage data

## 📊 API Usage Examples

### Fetch Confirmed Exoplanets
```bash
curl "http://localhost:8080/tap/sync?query=SELECT TOP 10 * FROM ps WHERE pl_name IS NOT NULL&format=json"
```

### Make ML Prediction
```bash
curl -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{"features": [365.25, 1.0, 1.0, 288]}'
```

### Get Statistics
```bash
curl http://localhost:8080/api/stats
```

## 🔧 Configuration

### Environment Variables
- `PORT` - Server port (default: 8080)
- `NODE_ENV` - Environment mode (production/development)

### Customization
- Edit `production-server.js` to modify API endpoints
- Modify Flutter code in `lib/` directory
- Update ML model logic in the `/predict` endpoint

## 🚀 Deployment to Cloud

### Heroku
```bash
# Login to Heroku
heroku login

# Create new app
heroku create your-app-name

# Set buildpacks
heroku buildpacks:add heroku/nodejs

# Deploy
git push heroku main
```

### Vercel
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

### Railway
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway deploy
```

## 📱 Features

- **Exoplanet Categories**: Browse confirmed exoplanets, candidates, and false positives
- **NASA Data Integration**: Real-time access to NASA Exoplanet Archive
- **Machine Learning**: Built-in habitability prediction model
- **Statistics Dashboard**: Track model performance and usage
- **Responsive UI**: Beautiful, space-themed interface

## 🛠 Development

### Local Development
```bash
# Start development server
npm run dev

# Or run Flutter in web mode
flutter run -d chrome
```

### Building
```bash
# Build Flutter web app
npm run build

# Build and serve
npm run serve
```

## 📋 Requirements

- **Flutter SDK**: 3.0+
- **Node.js**: 16.0+
- **npm**: 8.0+

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Kill existing processes
pkill -f "node.*production-server.js"
# Or specify different port
PORT=3000 node production-server.js
```

### Flutter Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build web --release
```

### API Connectivity Issues
- Ensure internet connection for NASA API access
- Check CORS settings if running on different domains

## 📄 License

MIT License - Feel free to use and modify for your NASA Space Apps Challenge submission!

---

🌌 **Built for NASA Space Apps Challenge** - Exploring the cosmos through code!