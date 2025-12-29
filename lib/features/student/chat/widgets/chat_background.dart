import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EtherealBackground extends StatelessWidget {
  const EtherealBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. White Base
        Container(color: const Color(0xFFF5F5FA)),

        // 2. The Purple/Pink Orbs (Positioned blobs)
        Positioned(
          top: -100,
          right: -100,
          child: _buildOrb(const Color(0xFFE0C3FC), 300),
        ),
        Positioned(
          top: 100,
          left: -50,
          child: _buildOrb(const Color(0xFF8EC5FC), 250),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: 30, duration: 4.seconds), // Subtle floating animation

        Positioned(
          bottom: 100,
          right: -20,
          child: _buildOrb(const Color(0xFFD4E0FC), 300),
        ),

        // 3. The "Frost" Glass Effect (Blur over the blobs)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
          child: Container(
            color: Colors.white.withOpacity(0.1), // Slight overlay
          ),
        ),
      ],
    );
  }

  Widget _buildOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.6),
      ),
    );
  }
}
