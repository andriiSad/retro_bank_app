import 'package:flutter/material.dart';

class AppTextButton extends StatefulWidget {
  const AppTextButton({
    required this.text,
    required this.textStyle,
    required this.onPressed,
    super.key,
  });

  final String text;
  final TextStyle textStyle;
  final void Function()? onPressed;

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: isPressed ? const Offset(3, 4) : Offset.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.black,
          border: Border.all(
            color: Colors.white,
          ),
          boxShadow: [
            BoxShadow(
              color: isPressed ? Colors.transparent : Colors.white,
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
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 7,
            ),
            child: Text(
              widget.text,
              style: widget.textStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
