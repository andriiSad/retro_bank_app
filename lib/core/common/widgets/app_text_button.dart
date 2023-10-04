import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';

class AppTextButton extends StatefulWidget {
  const AppTextButton({
    required this.text,
    required this.onPressed,
    this.textColor = Colors.black,
    this.fillColor = Colors.white,
    this.shadowColor = Colors.black,
    this.textStyle,
    super.key,
  });

  final String text;
  final Color textColor;
  final Color fillColor;
  final Color shadowColor;
  final TextStyle? textStyle;
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
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 7,
            ),
            child: Text(
              widget.text,
              style: widget.textStyle ??
                  context.textTheme.bodyMedium!
                      .copyWith(color: widget.textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
