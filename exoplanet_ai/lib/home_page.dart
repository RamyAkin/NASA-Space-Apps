import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/option_card.dart';
import 'screens/placeholder_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _gradientStart = Color(0xFF050A1E);
  static const _gradientEnd = Color(0xFF0B1E44);

  List<Map<String, Object>> get _options => [
        {
          'icon': Icons.add_circle_outline,
          'title': 'Add or Test Exoplanet',
          'subtitle': 'Input new data or test it against the AI model',
        },
        {
          'icon': Icons.public,
          'title': 'Confirmed Exoplanets',
          'subtitle': 'Browse all known confirmed planets',
        },
        {
          'icon': Icons.search,
          'title': 'Candidate Planets',
          'subtitle': 'Explore potential new discoveries',
        },
        {
          'icon': Icons.report_off,
          'title': 'False Positives',
          'subtitle': 'Review and analyze rejected detections',
        },
        {
          'icon': Icons.bar_chart,
          'title': 'Model Statistics',
          'subtitle': 'Check AI accuracy and performance',
        },
        {
          'icon': Icons.settings,
          'title': 'Model Settings',
          'subtitle': 'Adjust hyperparameters for retraining',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isWide = width > 800;
        return Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_gradientStart, _gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Stars overlay
            Positioned.fill(
              child: Opacity(
                opacity: 0.18,
                child: Image.asset(
                  'assets/stars_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Blur vignette to soften edges
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
                child: Container(color: Colors.transparent),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 900 : double.infinity),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        // Title + subtitle
                        Text(
                          'A World Away 🌍',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(
                                blurRadius: 18,
                                color: Colors.cyanAccent.withOpacity(0.06),
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore and Train AI for Exoplanet Discovery',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Cards column
                        Column(
                          children: List.generate(_options.length, (i) {
                            final opt = _options[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: OptionCard(
                                index: i,
                                icon: opt['icon'] as IconData,
                                title: opt['title'] as String,
                                subtitle: opt['subtitle'] as String,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlaceholderScreen(
                                        title: opt['title'] as String,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}