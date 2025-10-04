const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3001;

// Enable CORS for all routes
app.use(cors());

// Base URL for NASA TAP service
const TAP_BASE_URL = 'https://exoplanetarchive.ipac.caltech.edu/TAP/sync';

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'NASA TAP proxy server is running',
    timestamp: new Date().toISOString()
  });
});

// Generic TAP proxy endpoint
app.get('/tap/sync', async (req, res) => {
  try {
    const { query, format = 'json' } = req.query;
    
    if (!query) {
      return res.status(400).json({ error: 'Missing query parameter' });
    }

    // Build the target URL with query parameters
    const params = new URLSearchParams({ query, format });
    const targetUrl = `${TAP_BASE_URL}?${params.toString()}`;
    
    console.log(`Proxying request to: ${targetUrl}`);
    
    // Dynamically import node-fetch (ES module)
    const fetch = (await import('node-fetch')).default;
    
    // Make the request to NASA TAP service
    const response = await fetch(targetUrl);
    
    if (!response.ok) {
      throw new Error(`NASA TAP service error: ${response.status} ${response.statusText}`);
    }
    
    const data = await response.text();
    const contentType = response.headers.get('content-type') || 'application/json';
    
    // Return the response with appropriate content type
    res.set('Content-Type', contentType);
    res.send(data);
    
  } catch (error) {
    console.error('Error proxying request:', error.message);
    res.status(500).json({ 
      error: 'Failed to fetch from NASA TAP service',
      message: error.message 
    });
  }
});

// Simplified endpoints for direct exoplanet data access
app.get('/exoplanets/confirmed', async (req, res) => {
  try {
    const limit = req.query.limit ? parseInt(req.query.limit) : null;
    const query = limit 
      ? `SELECT TOP ${limit} * FROM ps`
      : 'SELECT * FROM ps';
    
    req.query = { query, format: 'json' };
    // Reuse the TAP sync handler
    return app._router.handle({ ...req, url: '/tap/sync', method: 'GET' }, res);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/exoplanets/candidates', async (req, res) => {
  try {
    const limit = req.query.limit ? parseInt(req.query.limit) : null;
    const query = limit 
      ? `SELECT TOP ${limit} * FROM cumulative WHERE koi_disposition = 'CANDIDATE'`
      : `SELECT * FROM cumulative WHERE koi_disposition = 'CANDIDATE'`;
    
    req.query = { query, format: 'json' };
    // Reuse the TAP sync handler  
    return app._router.handle({ ...req, url: '/tap/sync', method: 'GET' }, res);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/exoplanets/false-positives', async (req, res) => {
  try {
    const limit = req.query.limit ? parseInt(req.query.limit) : null;
    const query = limit 
      ? `SELECT TOP ${limit} * FROM cumulative WHERE koi_disposition = 'FALSE POSITIVE'`
      : `SELECT * FROM cumulative WHERE koi_disposition = 'FALSE POSITIVE'`;
    
    req.query = { query, format: 'json' };
    // Reuse the TAP sync handler
    return app._router.handle({ ...req, url: '/tap/sync', method: 'GET' }, res);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start the server
app.listen(PORT, '127.0.0.1', () => {
  console.log('🚀 NASA TAP CORS proxy server started');
  console.log(`📡 Server running at: http://localhost:${PORT}`);
  console.log(`💚 Health check: http://localhost:${PORT}/health`);
  console.log(`🔗 TAP endpoint: http://localhost:${PORT}/tap/sync`);
  console.log(`🪐 Direct endpoints:`);
  console.log(`   • Confirmed: http://localhost:${PORT}/exoplanets/confirmed`);
  console.log(`   • Candidates: http://localhost:${PORT}/exoplanets/candidates`);
  console.log(`   • False Positives: http://localhost:${PORT}/exoplanets/false-positives`);
  console.log('📝 Press Ctrl+C to stop');
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n👋 Shutting down NASA TAP proxy server...');
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n👋 Shutting down NASA TAP proxy server...');
  process.exit(0);
});