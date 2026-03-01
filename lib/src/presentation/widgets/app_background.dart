import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AppBackground({super.key, required this.child, this.padding = const EdgeInsets.all(12)});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = Color.lerp(primary, Colors.black, 0.12) ?? primary;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative soft circle top-left
          Positioned(
            left: -60,
            top: -60,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Decorative soft circle bottom-right
          Positioned(
            right: -80,
            bottom: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Foreground content
          SafeArea(
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
