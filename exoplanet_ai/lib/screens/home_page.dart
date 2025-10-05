import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
 
class HomePage extends StatefulWidget {
  const HomePage({super.key});
 
  @override
  State<HomePage> createState() => _HomePageState();
}
 
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // Each planet now explicitly contains a route so it's always matched to an option
  final List<Map<String, String>> planets = [
    {'name': 'Add or Test', 'image': 'assets/exoplanet1.png', 'route': '/add-test'},
    {'name': 'Confirmed', 'image': 'assets/exoplanet2.png', 'route': '/confirmed'},
    {'name': 'Candidates', 'image': 'assets/exoplanet3.png', 'route': '/candidates'},
    {'name': 'False Positives', 'image': 'assets/exoplanet4.png', 'route': '/false-positives'},
    {'name': 'Model Stats', 'image': 'assets/exoplanet5.png', 'route': '/statistics'},
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
    final route = planets[selectedIndex]['route'];
    if (route != null && route.isNotEmpty) {
      Navigator.pushNamed(context, route);
    }
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToSelection(int index) {
  // We want the selected planet to appear at the top (angle == pi/2).
  // The planet position calculation uses (i*step + angleOffset + pi/2).
  // To make i == index evaluate to pi/2, we need angleOffset == -index*step.
  double step = 2 * pi / planets.length;
  double targetAngle = -index * step;
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
          // Animated orbital planets - render all planets and emphasize the one near the top
          // We'll compute an angular distance to the top (pi/2) and map that to scale & opacity.
          () {
            final step = 2 * pi / planets.length;
            // Build a list of indices and their distance so we can sort draw order (farthest first)
            final List<Map<String, dynamic>> order = [];
            for (int i = 0; i < planets.length; i++) {
              final anglePos = i * step + angleOffset + pi / 2;
              // normalize difference to [-pi, pi]
              double diff = anglePos - (pi / 2);
              while (diff > pi) diff -= 2 * pi;
              while (diff < -pi) diff += 2 * pi;
              final absDiff = diff.abs();
              order.add({'i': i, 'absDiff': absDiff, 'anglePos': anglePos});
            }
            // Sort so farthest (largest absDiff) are drawn first; closest drawn last (on top)
            order.sort((a, b) => (b['absDiff'] as double).compareTo(a['absDiff'] as double));

            return Stack(
              children: order.map<Widget>((entry) {
                final i = entry['i'] as int;
                final anglePos = entry['anglePos'] as double;
                final absDiff = entry['absDiff'] as double;

                // Map absDiff (0..pi) -> t in 0..1 where 1 means fully centered
                double t = (1.0 - (absDiff / pi)).clamp(0.0, 1.0);
                t = Curves.easeOut.transform(t);

                final double scale = 0.85 + (1.15 - 0.85) * t; // 0.85..1.15
                final double opacity = 0.25 + (1.0 - 0.25) * t; // 0.25..1.0

                final left = centerX + cos(anglePos) * radius - planetSize / 2;
                final top = sunCenterY - sin(anglePos) * radius - planetSize / 2;

                return Positioned(
                  left: left,
                  top: top,
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: GestureDetector(
                        onTap: () {
                          if (i == selectedIndex) {
                            _navigateToSelectedPage();
                          } else {
                            _animateToSelection(i);
                          }
                        },
                        child: Container(
                          width: planetSize,
                          height: planetSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.5 * t + 0.1),
                                blurRadius: 8 + 24 * t,
                                spreadRadius: 1 + 2 * t,
                              ),
                            ],
                          ),
                          child: (() {
                            final imgPath = planets[i]['image']!;
                            Widget imageWidget = Image.asset(
                              imgPath,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
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
                            );

                            // For the two problematic assets, apply a radial alpha mask
                            // so any semi-transparent edge pixels are faded out smoothly
                            // into the background. This avoids scaling and thick borders.
                            if (imgPath.endsWith('exoplanet1.png') || imgPath.endsWith('exoplanet5.png')) {
                              // Slightly different masks per asset — planet1 was nearly perfect,
                              // planet5 needs a bit more fade at the edge to remove hue.
                              final isFive = imgPath.endsWith('exoplanet5.png');
                              // planet1: gentle mask that worked well
                              // planet5: tighter mask + small center offset to correct artwork shift
                              final radius = isFive ? 0.52 : 0.5;
                              final stops = isFive ? const [0.0, 0.90, 1.0] : const [0.0, 0.92, 1.0];
                              final center = isFive ? const Alignment(-0.04, -0.04) : Alignment.center;

                              return ClipOval(
                                child: ShaderMask(
                                  shaderCallback: (rect) => RadialGradient(
                                    center: center,
                                    radius: radius,
                                    colors: [Colors.white, Colors.white, Colors.transparent],
                                    stops: stops,
                                  ).createShader(rect),
                                  blendMode: BlendMode.dstIn,
                                  child: imageWidget,
                                ),
                              );
                            }

                            return ClipOval(child: imageWidget);
                          })(),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }(),
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