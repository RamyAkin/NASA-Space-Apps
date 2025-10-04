import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionCard extends StatefulWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  bool _hover = false;
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // staggered fade-in
    _timer = Timer(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onEnter(PointerEvent _) => setState(() => _hover = true);
  void _onExit(PointerEvent _) => setState(() => _hover = false);

  @override
  Widget build(BuildContext context) {
    final scale = _hover ? 1.025 : 1.0;
    return MouseRegion(
      onEnter: kIsWeb ? _onEnter : null,
      onExit: kIsWeb ? _onExit : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 360),
          opacity: _visible ? 1 : 0,
          curve: Curves.easeOut,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 160),
            scale: scale,
            curve: Curves.easeOutBack,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_hover ? 0.45 : 0.28),
                        blurRadius: _hover ? 20 : 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Icon circle with gradient
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.cyanAccent.shade200, Colors.purpleAccent.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.12),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Icon(widget.icon, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      // Texts
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.subtitle,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, color: Colors.white70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}