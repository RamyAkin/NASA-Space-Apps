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
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF050A1E), Color(0xFF0B1E44)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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

          // Page content with custom nav bar
          SafeArea(
            child: Column(
              children: [
                // Custom NavBar
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
                            'A World Away',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
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
                              _navButton(context, 'Add/Test', '/add-test'),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _navButton(context, 'Confirmed', '/confirmed'),
                              const SizedBox(width: 16),
                              _navButton(context, 'Candidates', '/candidates'),
                              const SizedBox(width: 16),
                              _navButton(context, 'False+', '/false-positives'),
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
                      vertical: 20,
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
    final isCurrentRoute = ModalRoute.of(context)?.settings.name == route;
    
    return TextButton(
      onPressed: () {
        if (route == '/') {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      style: TextButton.styleFrom(
        foregroundColor: isCurrentRoute ? Colors.cyanAccent : Colors.white70,
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: isCurrentRoute ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}