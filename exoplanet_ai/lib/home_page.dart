import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:provider/provider.dart';
import 'widgets/option_card.dart';
import 'screens/placeholder_screen.dart';
import 'screens/confirmed_screen.dart';
import 'screens/candidates_screen.dart';
import 'screens/false_positives_screen.dart';

/// Clean HomePage implementation. Keeps UI simple and valid.
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
      ];

  void _onOptionTap(BuildContext context, String title) {
    if (title.contains('Confirmed')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfirmedScreen()));
    } else if (title.contains('Candidate')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CandidatesScreen()));
    } else if (title.contains('False')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const FalsePositivesScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isWide = width > 800;
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_gradientStart, _gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.18,
                child: Image.asset('assets/stars_bg.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6), child: Container(color: Colors.transparent)),
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
                        Text('A World Away 🌍', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text('Explore and Train AI for Exoplanet Discovery', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 24),
                        Column(
                          children: List.generate(_options.length, (i) {
                            final opt = _options[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: OptionCard(index: i, icon: opt['icon'] as IconData, title: opt['title'] as String, subtitle: opt['subtitle'] as String, onTap: () => _onOptionTap(context, opt['title'] as String)),
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
