import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgButton extends StatefulWidget {
  const AppSvgButton({
    required this.assetPath,
    required this.onPressed,
    this.fillColor = Colors.white,
    this.shadowColor = Colors.black,
    this.size = 50.0, // Adjust the size of the circular button
    super.key,
  });

  final String assetPath;
  final Color fillColor;
  final Color shadowColor;
  final double size;
  final void Function()? onPressed;

  @override
  State<AppSvgButton> createState() => _AppSvgButtonState();
}

class _AppSvgButtonState extends State<AppSvgButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: isPressed ? const Offset(3, 4) : Offset.zero,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Make the button circular
          color: widget.fillColor,
          border: Border.all(
            color: widget.shadowColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isPressed ? Colors.transparent : widget.shadowColor,
              offset: isPressed ? Offset.zero : const Offset(3, 4),
            ),
          ],
        ),
        child: InkWell(
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          onTap: widget.onPressed,
          child: Center(
            child: SvgPicture.asset(
              widget.assetPath,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
