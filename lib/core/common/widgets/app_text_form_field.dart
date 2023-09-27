import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.controller,
    this.filled = false,
    this.obscureText = false,
    this.readOnly = false,
    super.key,
    this.validator,
    this.fillColor,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.hintStyle,
  });

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
    return TextFormField(
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
          borderRadius: BorderRadius.circular(90),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(90),
          borderSide: BorderSide(
            color: context.theme.primaryColor,
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
    );
  }
}
