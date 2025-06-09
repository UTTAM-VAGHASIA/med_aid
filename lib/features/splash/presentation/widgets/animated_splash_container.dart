import 'package:flutter/material.dart';

class AnimatedSplashContainer extends StatelessWidget {
  final Offset position;
  final Size size;
  final Color color;
  final Offset breathingOffset;
  final Duration duration;
  final Curve curve;

  const AnimatedSplashContainer({
    super.key,
    required this.position,
    required this.size,
    required this.color,
    this.breathingOffset = const Offset(1.0, 1.0),
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOutQuint,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      top: position.dy,
      left: position.dx + breathingOffset.dx,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
} 