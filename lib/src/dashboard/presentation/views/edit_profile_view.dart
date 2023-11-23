import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retro_bank_app/core/enums/update_user_action.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
import 'package:retro_bank_app/core/utils/core_utils.dart';
import 'package:retro_bank_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:retro_bank_app/src/dashboard/presentation/widgets/edit_profile_form.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  File? pickedImage;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  bool get usernameChanged =>
      context.user?.username.trim() != usernameController.text.trim();
  bool get emailChanged => emailController.text.isNotEmpty;
  bool get passwordChanged => passwordController.text.trim().isNotEmpty;

  bool get imageChanged => pickedImage != null;

  bool get nothingChanged =>
      !usernameChanged && !emailChanged && !passwordChanged && !imageChanged;

  @override
  void initState() {
    super.initState();
    final user = context.user;
    usernameController.text = user!.username.trim();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackBar(context, 'Profile updated successfully');
          pickedImage = null;
          // context.pop();
        } else if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text(
              'Edit Profile',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (nothingChanged) context.pop();
                  final bloc = context.read<AuthBloc>();
                  if (passwordChanged) {
                    if (oldPasswordController.text.trim().isEmpty) {
                      CoreUtils.showSnackBar(
                        context,
                        'Please enter your old password',
                      );
                      return;
                    } else {
                      bloc.add(
                        UpdateUserEvent(
                          userData: jsonEncode({
                            'oldPassword': oldPasswordController.text.trim(),
                            'newPassword': passwordController.text.trim(),
                          }),
                          action: UpdateUserAction.password,
                        ),
                      );
                    }
                    bloc.add(
                      UpdateUserEvent(
                        userData: passwordController.text.trim(),
                        action: UpdateUserAction.password,
                      ),
                    );
                  }
                  if (usernameChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        userData: usernameController.text.trim(),
                        action: UpdateUserAction.username,
                      ),
                    );
                  }
                  if (emailChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        userData: emailController.text.trim(),
                        action: UpdateUserAction.email,
                      ),
                    );
                  }
                  if (imageChanged) {
                    bloc.add(
                      UpdateUserEvent(
                        userData: pickedImage,
                        action: UpdateUserAction.profilePic,
                      ),
                    );
                  }
                },
                child: state is AuthLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      )
                    : StatefulBuilder(
                        builder: (_, refresh) {
                          usernameController.addListener(() => refresh(() {}));
                          emailController.addListener(() => refresh(() {}));
                          passwordController.addListener(() => refresh(() {}));
                          return Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: nothingChanged
                                  ? Colors.grey
                                  : Colors.blueAccent,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Builder(
                builder: (context) {
                  final user = context.user!;
                  final userImage =
                      user.photoUrl == null || user.photoUrl!.isEmpty
                          ? null
                          : user.photoUrl;
                  return Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: const Svg(MediaRes.robotAvatar),
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.multiply,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: pickedImage != null
                                  ? FileImage(pickedImage!)
                                  : userImage != null
                                      ? CachedNetworkImageProvider(
                                          userImage,
                                        ) as ImageProvider
                                      : const Svg(MediaRes.robotAvatar),
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.multiply,
                              ),
                            ),
                          ),
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: pickImage,
                            icon: Icon(
                              pickedImage != null || user.photoUrl != null
                                  ? Icons.edit
                                  : Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'We recomend an image of at least 400x400',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Gap(20),
              EditProfileForm(
                usernameController: usernameController,
                emailController: emailController,
                oldPasswordController: oldPasswordController,
                passwordController: passwordController,
              ),
            ],
          ),
        );
      },
    );
  }
}
