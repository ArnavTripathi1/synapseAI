import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmpathyAvatar extends StatelessWidget {
  final double size;

  const EmpathyAvatar({super.key, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // LAYER 1: Ambient Back Glow (The aura behind the ball)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF63A4FF).withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: -5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.1, 1.1), duration: 3.seconds),

          // LAYER 2: The Main Sphere (Clipped to keep internal waves inside)
          ClipOval(
            child: Container(
              width: size * 0.9,
              height: size * 0.9,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFA1C4FD), // Soft Blue top
                    Color(0xFF8FD3F4), // Cyan middle
                    Color(0xFF6C63FF), // Deep Lavender bottom
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  // Internal Wave 1 (Bottom Right Darker Swirl)
                  Positioned(
                    bottom: -size * 0.4,
                    right: -size * 0.3,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFF5D5FEF).withOpacity(0.4), // Purple tint
                          ],
                        ),
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                      .move(begin: const Offset(0, 0), end: const Offset(-5, -5), duration: 4.seconds),

                  // Internal Wave 2 (The Cyan "S" curve in the middle)
                  Positioned(
                    top: -size * 0.1,
                    left: -size * 0.2,
                    child: Container(
                      width: size * 0.9,
                      height: size * 0.9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFE0FFFF).withOpacity(0.6), // Light Cyan
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.05, 1.05), duration: 5.seconds),

                  // Internal Wave 3 (Central Light Core)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size * 0.5,
                      height: size * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.9), // Bright center
                            const Color(0xFF8FD3F4).withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.8],
                        ),
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                      .fade(begin: 0.6, end: 1.0, duration: 2.seconds), // Pulsing light
                ],
              ),
            ),
          ),

          // LAYER 3: The Glass Rim (Simulates the thickness of the glass)
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.5), // Top left rim is bright
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.3), // Bottom right rim reflection
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // LAYER 4: The Specular Highlight (The "Wet" Reflection at top-left)
          Positioned(
            top: size * 0.15,
            left: size * 0.18,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: size * 0.25,
                height: size * 0.12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.elliptical(size, size * 0.5)),
                ),
              ),
            ),
          ).animate().fade(duration: 1.seconds, curve: Curves.easeIn),

          // LAYER 5: Secondary small highlight (for extra gloss)
          Positioned(
            top: size * 0.22,
            left: size * 0.16,
            child: Container(
              width: size * 0.04,
              height: size * 0.04,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
