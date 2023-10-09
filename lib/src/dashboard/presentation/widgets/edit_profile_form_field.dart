import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_form_field.dart';

class EditProfileFormField extends StatelessWidget {
  const EditProfileFormField({
    required this.title,
    required this.controller,
    this.readOnly = false,
    this.hintText,
    super.key,
  });

  final String title;
  final TextEditingController controller;
  final String? hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const Gap(10),
        AppTextFormField(
          controller: controller,
          hintText: hintText,
          readOnly: readOnly,
        ),
      ],
    );
  }
}
