import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
 
class HomePage extends StatefulWidget {
  const HomePage({super.key});
 
  @override
  State<HomePage> createState() => _HomePageState();
}
 
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> planets = [
    {'name': 'Add or Test', 'image': 'assets/exoplanet1.png'},
    {'name': 'Confirmed', 'image': 'assets/exoplanet2.png'},
    {'name': 'Candidates', 'image': 'assets/exoplanet3.png'},
    {'name': 'False Positives', 'image': 'assets/exoplanet4.png'},
    {'name': 'Model Stats', 'image': 'assets/exoplanet5.png'},
  ];
 
  double angleOffset = 0.0;
  int selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          angleOffset = _animation.value;
        });
      });
  }
 
  void _rotate(int direction) {
    int newIndex = (selectedIndex + direction) % planets.length;
    if (newIndex < 0) newIndex += planets.length;
    _animateToSelection(newIndex);
  }

  void _navigateToSelectedPage() {
    switch (selectedIndex) {
      case 0: // Add or Test
        Navigator.pushNamed(context, '/add-test');
        break;
      case 1: // Confirmed
        Navigator.pushNamed(context, '/confirmed');
        break;
      case 2: // Candidates
        Navigator.pushNamed(context, '/candidates');
        break;
      case 3: // False Positives
        Navigator.pushNamed(context, '/false-positives');
        break;
      case 4: // Model Stats
        Navigator.pushNamed(context, '/statistics');
        break;
    }
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToSelection(int index) {
    double targetAngle = index * (2 * pi / planets.length);
    double currentAngle = angleOffset;
    
    // Find shortest rotation path
    double diff = targetAngle - currentAngle;
    if (diff > pi) diff -= 2 * pi;
    if (diff < -pi) diff += 2 * pi;
    
    _animation = Tween<double>(
      begin: currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    selectedIndex = index;
    _controller.reset();
    _controller.forward().then((_) {
      angleOffset = targetAngle;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sunDiameter = size.width * 0.5;
    final centerX = size.width / 2;
    final double planetSize = 110;
    final double sunCenterY = size.height;
    final double minTopMargin = 120;
    final double maxAllowedRadius = sunCenterY - minTopMargin - planetSize / 2;
    final double calculatedRadius = size.width * 0.35; // Reduced from 0.6 to 0.35 to bring orbit closer
    final double radius = min(calculatedRadius, maxAllowedRadius);
 
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Starry background
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.black);
              },
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
                child: Center(
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
              ),
            ),
          ),
          // Star as a semi-circle at the bottom
          Positioned(
            left: (size.width - sunDiameter) / 2,
            bottom: 0,
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.5,
                child: ClipOval(
                  child: Container(
                    width: sunDiameter,
                    height: sunDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        'assets/exostar.png',
                        width: sunDiameter,
                        height: sunDiameter,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.orange.shade300,
                                  Colors.orange.shade600,
                                  Colors.orange.shade800,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Animated orbital planets - only show the centered one
          for (int i = 0; i < planets.length; i++)
            if (i == selectedIndex) // Only show the selected planet
              Positioned(
                left: centerX + cos(i * (2 * pi / planets.length) + angleOffset + pi/2) * radius - planetSize / 2,
                top: sunCenterY - sin(i * (2 * pi / planets.length) + angleOffset + pi/2) * radius - planetSize / 2,
                child: GestureDetector(
                  onTap: _navigateToSelectedPage,
                  child: Container(
                    width: planetSize,
                    height: planetSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.5),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        planets[i]['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade300, Colors.blue.shade600],
                              ),
                            ),
                            child: const Icon(
                              Icons.public,
                              color: Colors.white,
                              size: 35,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          // Arrows and selected planet at the top of the arc
          Positioned(
            top: 64 + 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_left, color: Color(0xFFE9CC6C), size: 36),
                  onPressed: () => _rotate(-1),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: _navigateToSelectedPage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE9CC6C),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      planets[selectedIndex]['name']!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: const Icon(Icons.arrow_right, color: Color(0xFFE9CC6C), size: 36),
                  onPressed: () => _rotate(1),
                ),
              ],
            ),
          ),
          // Instructions below arrows
          Positioned(
            top: 64 + 16 + 60 + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Use arrows to navigate or tap planets directly',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button above to explore',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}