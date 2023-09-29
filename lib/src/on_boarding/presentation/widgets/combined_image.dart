import 'package:flutter/material.dart';

class CombinedImage extends StatefulWidget {
  const CombinedImage({
    required this.topImagePath,
    required this.bottomImagePath,
    this.imageSeparationIndex = 0.7,
    super.key,
  });

  final String topImagePath;
  final String bottomImagePath;
  final double imageSeparationIndex;

  @override
  State<CombinedImage> createState() => _CombinedImageState();
}

class _CombinedImageState extends State<CombinedImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: ValueKey<int>(
        widget.topImagePath.hashCode,
      ),
      children: [
        AnimatedBuilder(
          animation: animationController,
          builder: (_, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animationController),
              child: child,
            );
          },
          child: ClipPath(
            clipper: TopDiagonalClipper(
              widget.imageSeparationIndex,
            ),
            child: Image.asset(
              widget.topImagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animationController),
              child: child,
            );
          },
          child: ClipPath(
            clipper: BottomDiagonalClipper(
              widget.imageSeparationIndex,
            ),
            child: Image.asset(
              widget.bottomImagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        CustomPaint(
          size: const Size(double.maxFinite, double.maxFinite),
          painter: DiagonalLinePainter(
            widget.imageSeparationIndex,
          ),
        ),
      ],
    );
  }
}

class TopDiagonalClipper extends CustomClipper<Path> {
  TopDiagonalClipper(this.imageSeparationIndex);

  final double imageSeparationIndex;
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * imageSeparationIndex)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomDiagonalClipper extends CustomClipper<Path> {
  BottomDiagonalClipper(this.imageSeparationIndex);

  final double imageSeparationIndex;
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, 0) // Start at the bottom-left corner
      ..lineTo(
        0,
        size.height * imageSeparationIndex,
      )
      ..lineTo(0, size.height) // Draw a diagonal line to the top-right corner
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DiagonalLinePainter extends CustomPainter {
  DiagonalLinePainter(this.imageSeparationIndex);

  final double imageSeparationIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black // Change the color as needed
      ..strokeWidth = 10.0; // Adjust the line thickness as needed

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height * imageSeparationIndex),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
