import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_button.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/src/dashboard/presentation/widgets/edit_profile_form_field.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.usernameController,
    required this.emailController,
    required this.oldPasswordController,
    required this.passwordController,
    super.key,
  });

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController oldPasswordController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfileFormField(
          title: 'USERNAME',
          controller: usernameController,
          hintText: context.user!.username,
        ),
        const Gap(30),
        EditProfileFormField(
          title: 'EMAIL',
          controller: emailController,
          hintText: context.user!.email,
        ),
        const Gap(30),
        EditProfileFormField(
          title: 'CURRENT PASSWORD',
          controller: oldPasswordController,
          hintText: '******',
        ),
        const Gap(30),
        StatefulBuilder(
          builder: (_, setState) {
            oldPasswordController.addListener(() => setState(() {}));
            return EditProfileFormField(
              title: 'NEW PASSWORD',
              controller: passwordController,
              hintText: '******',
              readOnly: oldPasswordController.text.isEmpty,
            );
          },
        ),
        const Gap(30),
        Center(
          child: AppTextButton(
            text: 'Log out',
            onPressed: () {
              
            },
          ),
        ),
      ],
    );
  }
}
