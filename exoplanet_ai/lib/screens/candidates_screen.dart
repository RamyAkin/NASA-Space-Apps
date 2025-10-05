import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/exoplanet_provider.dart';
import '../widgets/planet_card.dart';

class CandidatesScreen extends StatefulWidget {
  const CandidatesScreen({super.key});

  @override
  State<CandidatesScreen> createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ExoplanetProvider>(context, listen: false);
      provider.loadCandidates(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<ExoplanetProvider>(context, listen: false);
      provider.loadCandidates();
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
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
                              onPressed: () => Navigator.pushNamed(context, '/confirmed'),
                              child: Text('Confirmed', style: GoogleFonts.poppins(color: Colors.black)),
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
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Consumer<ExoplanetProvider>(
              builder: (context, provider, child) {
          if (provider.candidates.isEmpty && provider.candidatesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          if (provider.error != null && provider.candidates.isEmpty) {
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
                    onPressed: () => provider.loadCandidates(refresh: true),
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
                      'Candidate Planets',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${provider.candidates.length} candidate planets loaded',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: provider.candidates.isEmpty && !provider.candidatesLoading
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
                        itemCount: provider.candidates.length + (provider.candidatesHasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= provider.candidates.length) {
                            return const Center(
                              child: CircularProgressIndicator(color: Colors.orange),
                            );
                          }

                          final planet = provider.candidates[index];
                          return PlanetCard(
                            planet: planet,
                            accentColor: Colors.orange,
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
