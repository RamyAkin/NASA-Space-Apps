import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/exoplanet_provider.dart';
import '../widgets/planet_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// ...existing imports

class ConfirmedScreen extends StatefulWidget {
  const ConfirmedScreen({super.key});

  @override
  State<ConfirmedScreen> createState() => _ConfirmedScreenState();
}

class _ConfirmedScreenState extends State<ConfirmedScreen> {
  late ScrollController _scrollController;
  Map<String, dynamic>? _modelStats;
  bool _statsLoading = false;
  String? _statsError;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ExoplanetProvider>(context, listen: false);
      provider.loadConfirmed(refresh: true);
    });
    // Load model stats for small summary cards
    _loadModelStats();
  }

  Future<void> _loadModelStats() async {
    setState(() {
      _statsLoading = true;
      _statsError = null;
    });

    try {
      const String _aiApiBase = String.fromEnvironment('API_AI_BASE', defaultValue: 'http://localhost:3001');
      final resp = await http.get(Uri.parse('$_aiApiBase/ai/stats'), headers: {'Accept': 'application/json'});
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          _modelStats = data as Map<String, dynamic>?;
          _statsLoading = false;
        });
      } else {
        throw Exception('Status ${resp.statusCode}');
      }
    } catch (e) {
      setState(() {
        _statsError = e.toString();
        _statsLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<ExoplanetProvider>(context, listen: false);
      provider.loadConfirmed();
    }
  }

  @override
  Widget build(BuildContext context) {
  // size not used here; removed to avoid unused-variable warnings
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Starry background
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ),
          ),
          // Yellow app bar at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 64,
            child: Container(
              color: const Color(0xFFE9CC6C),
              child: SafeArea(
                child: SizedBox(
                  height: 56,
                  child: Stack(
                    children: [
                      // Centered title
                      Center(
                        child: Text(
                          'A World Away',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      // Left back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                      // Right-side nav buttons
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/'),
                              child: Text('Home', style: GoogleFonts.poppins(color: Colors.black)),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Page content
          Positioned.fill(
            top: 64,
            child: Consumer<ExoplanetProvider>(
              builder: (context, provider, child) {
          if (provider.confirmed.isEmpty && provider.confirmedLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          }

          if (provider.error != null && provider.confirmed.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading data',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error ?? '',
                    style: GoogleFonts.poppins(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadConfirmed(refresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirmed Exoplanets',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${provider.confirmed.length} confirmed exoplanets loaded',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Small stats row (Total / Confirmed / Avg Confidence)
                    if (_statsLoading)
                      const SizedBox(
                        height: 28,
                        child: Center(child: CircularProgressIndicator(color: Colors.cyanAccent, strokeWidth: 2)),
                      )
                    else if (_modelStats != null)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total Predictions', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Text('${_modelStats!['total_predictions'] ?? 0}', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Confirmed', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Text('${_modelStats!['confirmed_predictions'] ?? 0}', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Avg Confidence', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Text('${((_modelStats!['avg_confidence'] ?? 0.0) * 100).toStringAsFixed(1)}%', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (_statsError != null)
                      Text('Stats unavailable', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              
              // Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: provider.confirmed.isEmpty && !provider.confirmedLoading
                    ? Center(
                        child: Text(
                          'No data available',
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 24),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(context),
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: provider.confirmed.length + (provider.confirmedHasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= provider.confirmed.length) {
                            return const Center(
                              child: CircularProgressIndicator(color: Colors.cyanAccent),
                            );
                          }

                          final planet = provider.confirmed[index];
                          return PlanetCard(
                            planet: planet,
                            accentColor: Colors.cyanAccent,
                            showAllStats: true,
                            onTap: () {
                              // TODO: Navigate to planet detail screen
                            },
                          );
                        },
                      ),
                ),
              ),
            ],
          );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1400) return 4;
    if (width > 1000) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
