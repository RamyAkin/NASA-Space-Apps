import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // keep the cosmic background look by using transparent scaffold color if desired
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: GoogleFonts.poppins()),
      ),
      body: Center(
        child: Text(
          'Coming Soon\n\n$title',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 20),
        ),
      ),
    );
  }
}