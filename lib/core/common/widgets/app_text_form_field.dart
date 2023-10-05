import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    super.key,
    this.validator,
    this.fillColor,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
  })  : filled = fillColor != null,
        shadowColor = fillColor == Colors.white ? Colors.black : Colors.white;

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool filled;
  final Color? fillColor;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final Color shadowColor;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            offset: hasError ? Offset.zero : const Offset(3, 4),
            color: hasError ? Colors.transparent : widget.shadowColor,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (widget.validator != null) {
            final validationResult = widget.validator!(value);
            if (validationResult != null) {
              setState(() {
                hasError = true;
              });
              return validationResult;
            }
          } else if (value == null || value.isEmpty) {
            setState(() {
              hasError = true;
            });
            return '*This field is required';
          }
          return widget.validator?.call(value);
        },
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(90)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 4,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 4,
            ),
          ),
          //overriding the default padding helps with that puffy look
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          filled: widget.filled,
          fillColor: widget.fillColor,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
