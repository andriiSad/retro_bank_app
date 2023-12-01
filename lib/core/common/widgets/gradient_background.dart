import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.child,
    required this.colors,
    super.key,
    this.begin,
    this.end,
  });
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin ?? Alignment.centerLeft,
          end: end ?? Alignment.centerRight,
          colors: colors,
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
