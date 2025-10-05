import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const AppShell({super.key, required this.child, this.title = 'A World Away', this.actions});

  @override
  Widget build(BuildContext context) {
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
          // Yellow app bar at the top (matches home)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 64,
            child: Container(
              color: const Color(0xFFE9CC6C),
              child: SafeArea(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // optional actions aligned to right via Spacer
                      if (actions != null) ...[
                        const SizedBox(width: 16),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Blur overlay to soften background
          Positioned.fill(
            top: 64,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Page content below the app bar
          Positioned.fill(
            top: 64 + 12,
            child: child,
          ),
        ],
      ),
    );
  }
}
