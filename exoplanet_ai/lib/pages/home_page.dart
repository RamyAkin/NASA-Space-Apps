import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/website_scaffold.dart';
import '../widgets/option_card.dart';
import 'add_or_test.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Map<String, Object>> get _options => [
        {
          'icon': Icons.add_circle_outline,
          'title': 'Add or Test Exoplanet',
          'subtitle': 'Input new data or test it against the AI model',
          'page': const AddOrTestPage(),
        },
        {
          'icon': Icons.public,
          'title': 'Confirmed Exoplanets',
          'subtitle': 'Browse all known confirmed planets',
          'page': const (),
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
    return WebsiteScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Title + subtitle
              Text(
                "A World Away 🌍",
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      blurRadius: 18,
                      color: Colors.cyanAccent.withAlpha(100),
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Explore and Train AI for Exoplanet Discovery",
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 500),

              // 🔳 Boxes (OptionCards)
              Column(
                children: List.generate(_options.length, (i) {
                  final opt = _options[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: OptionCard(
                      index: i,
                      icon: opt['icon'] as IconData,
                      title: opt['title'] as String,
                      subtitle: opt['subtitle'] as String,
                      onTap: () {
                        if (opt.containsKey('page') && opt['page'] is Widget) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => opt['page'] as Widget,
                            ),
                          );
                        } else {
                          // No page defined
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'The "${opt['title']}" page is not implemented yet.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
