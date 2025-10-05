import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// network fetching disabled — using hard-coded stats for offline/testing

class ModelStatsScreen extends StatefulWidget {
  const ModelStatsScreen({super.key});

  @override
  State<ModelStatsScreen> createState() => _ModelStatsScreenState();
}

class _ModelStatsScreenState extends State<ModelStatsScreen> {
  Map<String, dynamic>? _modelStats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadModelStats();
  }

  Future<void> _loadModelStats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    // Hard-coded stats (for offline/testing). Update values here as needed.
    await Future.delayed(const Duration(milliseconds: 200)); // simulate brief load
    setState(() {
      _modelStats = {
        'model_type': 'Random Forest Classifier',
        'training_samples': 9564,
        'features_count': 4,
        'last_updated': '2025-10-05',
        'total_predictions': 70,
        'confirmed_predictions': 70,
        'rejected_predictions': 0,
        'total_confidence': 67.8717343211174,
        'prediction_history': [
          {
            'timestamp': '2025-10-05T20:27:10.324Z',
            'confidence': 0.9998505115509033,
          },
          {
            'timestamp': '2025-10-05T19:30:39.246Z',
            'confidence': 0.8562766313552856,
          },
          {
            'timestamp': '2025-10-05T15:52:13.290Z',
            'confidence': 0.9976220726966858,
          }
        ],
        'api_calls_today': 12,
        'uptime_hours': 48.5,
      };
      _isLoading = false;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE9CC6C),
        elevation: 0,
        title: Text(
          'A World Away',
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/'),
            child: Text('Home', style: GoogleFonts.poppins(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/confirmed'),
            child: Text('Confirmed', style: GoogleFonts.poppins(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/candidates'),
            child: Text('Candidates', style: GoogleFonts.poppins(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/false-positives'),
            child: Text('False+', style: GoogleFonts.poppins(color: Colors.black)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Use the app's starry background (keeps the screen visually consistent)
          const SizedBox.shrink(),
          // Background stars
          Positioned.fill(
            child: Opacity(
              // make the starfield visible and consistent with the home screen
              opacity: 0.95,
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          // Blur effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Model Statistics',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Performance metrics and insights from the exoplanet detection model',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.cyanAccent),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error loading model statistics',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: GoogleFonts.poppins(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadModelStats,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_modelStats == null) {
      return Center(
        child: Text(
          'No model statistics available',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Model Overview
          _buildStatsCard(
            'Model Overview',
            Icons.analytics,
            Colors.cyanAccent,
            [
              _buildStatRow('Model Type', _modelStats!['model_type'] ?? 'Classification'),
              _buildStatRow('Training Dataset', '${_modelStats!['training_samples'] ?? 'Unknown'} samples'),
              _buildStatRow('Features Used', '${_modelStats!['features_count'] ?? 4} parameters'),
              _buildStatRow('Last Updated', _modelStats!['last_updated'] ?? 'Unknown'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Usage Statistics (approximate)
          _buildStatsCard(
            'Usage Statistics',
            Icons.bar_chart,
            Colors.orangeAccent,
            [
              _buildStatRow('Total Predictions', 'Estimated'),
              _buildStatRow('Confirmed Predictions', 'Majority'),
              _buildStatRow('Rejected Predictions', 'Minimal'),
              _buildStatRow('Average Confidence', 'High'),
              _buildStatRow('Confirmation Rate', 'Consistent'),
            ],
          ),
          
          const SizedBox(height: 16),
          // Note: Real-time activity removed for static/demo mode
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, IconData icon, Color color, List<Widget> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stats,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Real-time display helpers removed in static/demo mode.
}