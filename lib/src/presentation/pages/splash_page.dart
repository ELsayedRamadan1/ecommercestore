import 'dart:async';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final Animation<double> _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    // Keep splash visible for a bit
    Timer(const Duration(milliseconds: 1100), () {
      // After splash, navigator will be decided by RootPage in main
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // logo from assets/images/logo.png
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [const BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.12), blurRadius: 12, offset: Offset(0, 6))],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      // Provide a non-throwing fallback when asset not available (e.g. during tests)
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.storefront_rounded,
                        size: 56,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('متجر صغير', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 6),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
