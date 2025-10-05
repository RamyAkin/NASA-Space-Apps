import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

    try {
      // Call model stats endpoint
      final response = await http.get(
        Uri.parse('http://localhost:3001/ai/stats'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final stats = jsonDecode(response.body);
        setState(() {
          _modelStats = stats;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load model stats: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'A World Away',
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/'),
            child: Text('Home', style: GoogleFonts.poppins(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/confirmed'),
            child: Text('Confirmed', style: GoogleFonts.poppins(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/candidates'),
            child: Text('Candidates', style: GoogleFonts.poppins(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/false-positives'),
            child: Text('False+', style: GoogleFonts.poppins(color: Colors.white70)),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D1B2A),
                  Color(0xFF1B263B),
                  Color(0xFF415A77),
                ],
              ),
            ),
          ),
          // Background stars
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
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
          
          // Usage Statistics
          _buildStatsCard(
            'Usage Statistics',
            Icons.bar_chart,
            Colors.orangeAccent,
            [
              _buildStatRow('Total Predictions', '${_modelStats!['total_predictions'] ?? 0}'),
              _buildStatRow('Confirmed Predictions', '${_modelStats!['confirmed_predictions'] ?? 0}'),
              _buildStatRow('Rejected Predictions', '${_modelStats!['rejected_predictions'] ?? 0}'),
              _buildStatRow('Average Confidence', '${((_modelStats!['avg_confidence'] ?? 0.85) * 100).toStringAsFixed(2)}%'),
              _buildStatRow('Confirmation Rate', '${((_modelStats!['confirmation_rate'] ?? 0) * 100).toStringAsFixed(1)}%'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Real-time Activity
          _buildStatsCard(
            'Real-time Activity',
            Icons.access_time,
            Colors.purpleAccent,
            [
              _buildStatRow('API Calls Today', '${_modelStats!['api_calls_today'] ?? 0}'),
              _buildStatRow('Recent Predictions (24h)', '${_modelStats!['recent_predictions_24h'] ?? 0}'),
              _buildStatRow('Server Uptime', '${(_modelStats!['uptime_hours'] ?? 0).toStringAsFixed(2)} hours'),
              _buildStatRow('Last Prediction', _formatLastPrediction(_modelStats!['last_prediction'])),
            ],
          ),
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

  String _formatLastPrediction(dynamic lastPrediction) {
    if (lastPrediction == null) return 'Never';
    
    try {
      final timestamp = DateTime.parse(lastPrediction.toString());
      final now = DateTime.now();
      final difference = now.difference(timestamp);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}