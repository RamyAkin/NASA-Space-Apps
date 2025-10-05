import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/website_scaffold.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return WebsiteScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.cyanAccent.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              'Coming Soon',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'This feature is under development.',
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
