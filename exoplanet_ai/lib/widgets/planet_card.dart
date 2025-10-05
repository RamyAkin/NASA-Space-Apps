import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
import '../models/exoplanet.dart';
// import '../providers/exoplanet_provider.dart';

class PlanetCard extends StatefulWidget {
  final Exoplanet planet;
  final Color accentColor;
  final VoidCallback? onTap;
  final bool showAllStats;

  const PlanetCard({
    super.key,
    required this.planet,
    required this.accentColor,
    this.onTap,
    this.showAllStats = false,
  });

  @override
  State<PlanetCard> createState() => _PlanetCardState();
}

class _PlanetCardState extends State<PlanetCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _hover ? 1.02 : 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.accentColor.withOpacity(_hover ? 0.6 : 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Planet name with status indicator
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.accentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.planet.name,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.planet.status ?? 'Unknown',
                        style: GoogleFonts.poppins(
                          color: widget.accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Properties - show different data based on availability
                    _buildProperty('Radius', '${widget.planet.radius?.toStringAsFixed(2) ?? '-'} R⊕'),
                    const SizedBox(height: 6),
                    
                    // Show mass for confirmed planets, or equilibrium temp for candidates
                    if (widget.planet.mass != null)
                      _buildProperty('Mass', '${widget.planet.mass!.toStringAsFixed(2)} M⊕')
                    else if (widget.planet.equilibriumTemp != null)
                      _buildProperty('Planetary temp', '${widget.planet.equilibriumTemp!.toStringAsFixed(0)} K'),
                    const SizedBox(height: 6),
                    
                    _buildProperty('Period', '${widget.planet.orbitalPeriod?.toStringAsFixed(1) ?? '-'} days'),
                    
                    // Show additional data for candidates/false positives if available
                    // or for confirmed planets when showAllStats is true
                    if (widget.showAllStats || widget.planet.status != 'CONFIRMED') ...[
                      if (widget.planet.stellarRadius != null) ...[
                        const SizedBox(height: 6),
                        _buildProperty('Star R', '${widget.planet.stellarRadius!.toStringAsFixed(2)} R☉'),
                      ],
                      if (widget.planet.transitDuration != null) ...[
                        const SizedBox(height: 6),
                        _buildProperty('Transit', '${widget.planet.transitDuration!.toStringAsFixed(2)} hrs'),
                      ],
                    ],
                    
                    const Spacer(),
                    
                    // AI Reasoning (only for candidates and false positives)
                    // Commented out AI analysis
                    // if (widget.planet.status != 'CONFIRMED') 
                    //   _buildAIReasoning(),
                    
                    // Discovery info
                    if (widget.planet.discoveryYear != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Discovered: ${widget.planet.discoveryYear}',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProperty(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Widget _buildAIReasoning() {
  //   return Consumer<ExoplanetProvider>(
  //     builder: (context, provider, child) {
  //       if (provider.hasAIReasoning(widget.planet)) {
  //         final reasoning = provider.getCachedAIReasoning(widget.planet);
  //         if (reasoning != null) {
  //           return Container(
  //             margin: const EdgeInsets.only(bottom: 8),
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //             decoration: BoxDecoration(
  //               color: _getReasoningColor().withOpacity(0.2),
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(
  //                 color: _getReasoningColor().withOpacity(0.4),
  //                 width: 1,
  //               ),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   children: [
  //                     Icon(
  //                       Icons.psychology,
  //                       color: _getReasoningColor(),
  //                       size: 14,
  //                     ),
  //                     const SizedBox(width: 4),
  //                     Text(
  //                       _getReasoningTitle(),
  //                       style: GoogleFonts.poppins(
  //                         color: _getReasoningColor(),
  //                         fontSize: 11,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   _formatReasoning(reasoning),
  //                   style: GoogleFonts.poppins(
  //                     color: Colors.white,
  //                     fontSize: 10,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //       }
  //       
  //       // Show loading or trigger reasoning
  //       return Container(
  //         margin: const EdgeInsets.only(bottom: 8),
  //         child: FutureBuilder<Map<String, dynamic>?>(
  //           future: provider.getAIReasoning(widget.planet),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.withOpacity(0.2),
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     SizedBox(
  //                       width: 12,
  //                       height: 12,
  //                       child: CircularProgressIndicator(
  //                         strokeWidth: 2,
  //                         color: Colors.grey[400],
  //                       ),
  //                     ),
  //                     const SizedBox(width: 6),
  //                     Text(
  //                       'Analyzing...',
  //                       style: GoogleFonts.poppins(
  //                         color: Colors.grey[400],
  //                         fontSize: 10,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }
  //             
  //             if (snapshot.hasError) {
  //               return Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //                 child: Text(
  //                   'AI analysis unavailable',
  //                   style: GoogleFonts.poppins(
  //                     color: Colors.grey[600],
  //                     fontSize: 9,
  //                   ),
  //                 ),
  //               );
  //             }
  //             
  //             return const SizedBox.shrink();
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Color _getReasoningColor() {
  //   switch (widget.planet.status?.toUpperCase()) {
  //     case 'CANDIDATE':
  //       return Colors.orange;
  //     case 'FALSE POSITIVE':
  //       return Colors.red;
  //     default:
  //       return Colors.purple;
  //   }
  // }

  // String _getReasoningTitle() {
  //   switch (widget.planet.status?.toUpperCase()) {
  //     case 'CANDIDATE':
  //       return 'Why Candidate?';
  //     case 'FALSE POSITIVE':
  //       return 'Why Rejected?';
  //     default:
  //       return 'AI Analysis';
  //   }
  // }

  // String _formatReasoning(Map<String, dynamic> reasoning) {
  //   if (reasoning.containsKey('prediction')) {
  //     final predValue = reasoning['prediction'];
  //     final confidence = reasoning['confidence'];
  //     
  //     if (widget.planet.status?.toUpperCase() == 'CANDIDATE') {
  //       if (predValue == 1) {
  //         return 'AI confirms potential: ${(confidence * 100).toStringAsFixed(1)}% confidence. Awaiting additional observations.';
  //       } else {
  //         return 'AI suggests caution: ${(confidence * 100).toStringAsFixed(1)}% confidence in rejection. Needs more data.';
  //       }
  //     } else if (widget.planet.status?.toUpperCase() == 'FALSE POSITIVE') {
  //       if (predValue == 0) {
  //         return 'AI agrees with rejection: ${(confidence * 100).toStringAsFixed(1)}% confidence. Likely instrumental noise or stellar activity.';
  //       } else {
  //         return 'AI disagrees with rejection: ${(confidence * 100).toStringAsFixed(1)}% confidence it could be real. Worth re-examination.';
  //       }
  //     }
  //   }
  //   
  //   return 'Analysis complete';
  // }
}