import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.black,
        border: Border.all(
          color: Colors.white,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(3, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 7,
          ),
          child: Text(
            widget.text,
            style: context.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
