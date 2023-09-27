import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/res/colors.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Colours.gradient,
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
