import 'package:flutter/material.dart';

class CombinedImage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: TopDiagonalClipper(
            imageSeparationIndex,
          ),
          child: Image.asset(
            topImagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        ClipPath(
          clipper: BottomDiagonalClipper(
            imageSeparationIndex,
          ),
          child: Image.asset(
            bottomImagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        CustomPaint(
          size: const Size(double.maxFinite, double.maxFinite),
          painter: DiagonalLinePainter(
            imageSeparationIndex,
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
