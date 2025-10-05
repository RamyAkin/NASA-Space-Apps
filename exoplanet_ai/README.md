# 🌌 NASA Exoplanet Discovery Web App

A beautiful, interactive web application for exploring exoplanets using real NASA data and machine learning predictions. Built with Flutter Web and Node.js for the NASA Space Apps Challenge.

## 🚀 **One-Click Deploy to Railway**

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template/sUaB_x?referralCode=NASA)

## ✨ **Features**

- 🪐 **Interactive Exoplanet Explorer** - Navigate through confirmed exoplanets, candidates, and false positives
- 🔭 **Real NASA Data** - Live integration with NASA Exoplanet Archive
- 🤖 **AI Predictions** - Machine learning model for habitability assessment  
- 🌟 **Beautiful UI** - Space-themed interface with orbital mechanics
- 📊 **Statistics Dashboard** - Track model performance and usage
- 📱 **Responsive Design** - Works on desktop, tablet, and mobile

## 🌐 **Live Demo**

[View Live App](https://your-app-name.railway.app) _(deployed on Railway)_

## 🛠 **Local Development**

```bash
# Clone the repository
git clone https://github.com/RamyAkin/NASA-Space-Apps.git
cd NASA-Space-Apps/exoplanet_ai

# Install dependencies
flutter pub get
npm install

# Run locally
./deploy-production.sh
```

### Or: run the backend in the background and the Flutter app in dev mode

If you prefer to run the Node.js server in the background and then run the Flutter app while the server is running, use the following commands.

1) Start Node.js server in the background (from the repo root or adjust path):

```bash
cd "/Users/ramyakin/NASA Space Apps/exoplanet_ai" && nohup node server.js > server.log 2>&1 &
```

This will start the Node server and write logs to `server.log`. The `nohup` and trailing `&` ensure the process keeps running after you close the terminal.

2) Run the Flutter app (in another terminal window/tab):

```bash
cd "/Users/ramyakin/NASA Space Apps/exoplanet_ai"
flutter run -d chrome
```

3) When you're done, stop the background Node process. You can find and kill it like this:

```bash
# Find Node process (example)
lsof -i :3001

# or kill by searching for node
pkill -f "node server.js"
```

Notes and tips
- If you run the Node server on a non-standard port, update the API base URLs in the Flutter code (search for `API_AI_BASE` / `API_TAP_BASE` or replace `localhost:3001`).
- If you see CORS issues when the Flutter app tries to call the backend, ensure the Node server is started with CORS enabled (the code already uses `cors()` by default).
- For production builds of the frontend, run `flutter build web --release` and serve the files from `build/web` using the Node server or any static host.

### AI prediction input format

Important: the AI model expects numeric values in exponential notation (as numbers, not strings) in this exact format. When calling the prediction endpoint, send JSON with numeric literals like:

```json
"period": 8.6893015e+00,
"duration": 2.5630000e+00,
"depth": 1.1170000e+03,
"ror": 2.9843001e-02
```

If values are sent as free-form strings or in a different numeric format the model may fail to parse them or produce incorrect results.

## 🔧 **Tech Stack**

- **Frontend**: Flutter Web
- **Backend**: Node.js + Express
- **Data Source**: NASA Exoplanet Archive TAP API
- **ML**: Custom habitability prediction model
- **Deployment**: Railway

## 📱 **Screenshots**

_[Add screenshots of your app here]_

## 🤝 **Contributing**

Built for NASA Space Apps Challenge 2025 - feel free to fork and improve!

---

🌟 **NASA Space Apps Challenge 2025** - Exploring the cosmos through code!
