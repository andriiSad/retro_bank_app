import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_form_field.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
//TODO(Add custom static validator) : Add validator for email and password

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.confirmPasswordController,
    required this.usernameController,
    required this.photoController,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController usernameController;
  final TextEditingController photoController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;
  File? pickedImage;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.photoController.text = image.path;
        pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: pickedImage != null
                    ? FileImage(pickedImage!)
                    : const Svg(MediaRes.robotAvatar) as ImageProvider,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.multiply,
                ),
              ),
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: pickImage,
              icon: Icon(
                pickedImage != null ? Icons.edit : Icons.add_a_photo,
                color: Colors.white,
              ),
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'We recomend an image of at least 400x400',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ),
          const Gap(20),
          AppTextFormField(
            controller: widget.usernameController,
            hintText: 'Username',
            fillColor: Colors.white,
          ),
          const Gap(25),
          AppTextFormField(
            controller: widget.emailController,
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            fillColor: Colors.white,
          ),
          const Gap(25),
          AppTextFormField(
            controller: widget.passwordController,
            hintText: 'Password',
            obscureText: obscurePassword,
            fillColor: Colors.white,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
          ),
          const Gap(25),
          AppTextFormField(
            controller: widget.confirmPasswordController,
            hintText: 'Confirm Password',
            obscureText: obscurePassword,
            fillColor: Colors.white,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? IconlyLight.show : IconlyLight.hide,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
