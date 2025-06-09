import 'dart:math';
import 'package:flutter/material.dart';

class FlipLogo extends StatefulWidget {
  final String logoPath;
  final double opacity;
  final double scale;

  const FlipLogo({
    super.key,
    required this.logoPath,
    required this.opacity,
    required this.scale,
  });

  @override
  State<FlipLogo> createState() => _FlipLogoState();
}

class _FlipLogoState extends State<FlipLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    // Start animation when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)  // Perspective
            ..rotateY(_animation.value),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: widget.opacity,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 800),
              scale: widget.scale,
              curve: Curves.easeOutBack,
              child: Image.asset(
                widget.logoPath,
                width: 160,
                height: 160,
              ),
            ),
          ),
        );
      },
    );
  }
} 