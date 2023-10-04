import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
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
  }) : filled = fillColor != null;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return validator?.call(value);
            },
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: readOnly,
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
          //overriding the default padding helps with that puffy look
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          filled: filled,
          fillColor: fillColor,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: hintStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
