import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebsiteScaffold extends StatelessWidget {
  final Widget body;

  const WebsiteScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ⭐ Background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.asset('assets/background.png', fit: BoxFit.cover),
            ),
          ),
          // Blur vignette
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Page content with custom nav bar
          SafeArea(
            child: Column(
              children: [
                // 🌌 Custom NavBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: SizedBox(
                    height: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Center logo/title
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/'),
                          child: Text(
                            'Uclan Tech',
                            style: GoogleFonts.abel(
                              fontSize: 28,
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _navButton(context, 'Home', '/'),
                              const SizedBox(width: 16),
                              _navButton(context, 'Explore', '/explore'),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _navButton(context, 'Candidates', '/candidates'),
                              const SizedBox(width: 16),
                              _navButton(context, 'Flase Positives', '/falsepositives'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Actual page body scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context, String label, String route) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(
        label,
        style: GoogleFonts.abel(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
