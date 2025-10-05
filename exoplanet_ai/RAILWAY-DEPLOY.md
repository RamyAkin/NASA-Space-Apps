# 🚂 Deploy NASA Exoplanet App to Railway

## Step-by-Step Deployment Guide

### **1. 📋 Prerequisites**
- ✅ GitHub repository (you have this: `RamyAkin/NASA-Space-Apps`)
- ✅ Railway account (sign up at [railway.app](https://railway.app))
- ✅ Code pushed to GitHub (✅ Done!)

### **2. 🚀 Deploy to Railway**

#### **Option A: One-Click Deploy (Easiest)**
1. Go to [railway.app](https://railway.app)
2. Click **"Login with GitHub"**
3. Click **"New Project"** 
4. Click **"Deploy from GitHub repo"**
5. Select your repository: `RamyAkin/NASA-Space-Apps`
6. Select the folder: `exoplanet_ai`
7. Click **"Deploy Now"**

#### **Option B: Using Railway CLI**
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Navigate to your project
cd "/Users/ramyakin/NASA Space Apps/exoplanet_ai"

# Initialize Railway project
railway init

# Deploy
railway up
```

### **3. ⚙️ Railway Configuration**

Railway will automatically:
- ✅ Detect Node.js project
- ✅ Install Flutter SDK
- ✅ Run `flutter pub get && flutter build web --release`
- ✅ Start your production server
- ✅ Assign a public URL

### **4. 🔧 Environment Variables (Optional)**

In Railway dashboard, you can set:
```
PORT=8080
NODE_ENV=production
```

### **5. 📱 Access Your Live App**

After deployment (2-3 minutes), Railway provides:
- 🌐 **Public URL**: `https://your-app-name.railway.app`
- 📊 **Metrics Dashboard**
- 📋 **Logs and Monitoring**
- 🔄 **Auto-redeploy on Git push**

### **6. 🎯 What Gets Deployed**

Your Railway app includes:
- ✅ **Flutter Web App** (frontend)
- ✅ **Node.js API Server** (backend)
- ✅ **NASA TAP Proxy** (data access)
- ✅ **ML Prediction Endpoint**
- ✅ **Statistics Dashboard**

### **7. 🔄 Auto-Updates**

Every time you push to GitHub:
```bash
git add .
git commit -m "Update: improved animations"
git push origin main
```
Railway automatically redeploys your app! 🚀

### **8. 📊 Monitoring**

Railway provides:
- **Real-time logs**
- **CPU/Memory usage**
- **Request metrics** 
- **Deployment history**
- **Custom domains**

---

## 🎉 **That's It!**

Your NASA Exoplanet Discovery app will be live on the internet with:
- ✅ **Professional URL**
- ✅ **SSL Certificate** (HTTPS)
- ✅ **Global CDN**
- ✅ **Auto-scaling**
- ✅ **99.9% Uptime**

Perfect for your NASA Space Apps Challenge submission! 🌌

---

## 🆘 **Troubleshooting**

### **Build Fails**
- Check Railway build logs
- Ensure Flutter SDK is properly installed
- Verify all dependencies in package.json

### **App Won't Start**  
- Check that `production-server.js` exists
- Verify start command: `node production-server.js`
- Check port configuration (Railway auto-assigns)

### **Can't Access App**
- Wait 2-3 minutes for deployment
- Check Railway dashboard for deployment status
- Verify no build errors in logs

### **Need Help?**
- Railway has excellent documentation
- Discord community support
- GitHub issues for technical problems