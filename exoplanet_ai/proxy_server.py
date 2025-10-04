#!/usr/bin/env python3
"""
Simple CORS proxy server for NASA Exoplanet Archive TAP service.
Allows the Flutter web app to fetch data without browser CORS restrictions.
"""

import sys
import urllib.parse
import urllib.request
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

TAP_BASE_URL = 'https://exoplanetarchive.ipac.caltech.edu/TAP/sync'

@app.route('/tap/sync', methods=['GET'])
def proxy_tap():
    """Proxy TAP sync requests to NASA Exoplanet Archive"""
    try:
        # Get query parameters from the request
        query = request.args.get('query', '')
        format_param = request.args.get('format', 'json')
        
        if not query:
            return jsonify({'error': 'Missing query parameter'}), 400
        
        # Build the target URL
        params = urllib.parse.urlencode({
            'query': query,
            'format': format_param
        })
        target_url = f"{TAP_BASE_URL}?{params}"
        
        print(f"Proxying request to: {target_url}")
        
        # Make the request to NASA TAP service
        with urllib.request.urlopen(target_url) as response:
            data = response.read()
            content_type = response.headers.get('content-type', 'application/json')
        
        # Return the response with CORS headers
        if content_type.startswith('application/json'):
            return data, 200, {'Content-Type': 'application/json'}
        else:
            return data, 200, {'Content-Type': content_type}
            
    except Exception as e:
        print(f"Error proxying request: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'ok', 'message': 'NASA TAP proxy server is running'})

if __name__ == '__main__':
    print("Starting NASA TAP CORS proxy server...")
    print("Access at: http://localhost:8080")
    print("Health check: http://localhost:8080/health")
    print("TAP endpoint: http://localhost:8080/tap/sync")
    
    # Run on localhost:8080 in debug mode (port 5000 may be used by other services)
    app.run(host='127.0.0.1', port=8080, debug=True)