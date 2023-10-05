import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_button.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_card.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
import 'package:retro_bank_app/core/utils/core_utils.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:retro_bank_app/src/auth/presentation/views/sign_in_screen.dart';
import 'package:retro_bank_app/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:retro_bank_app/src/dashboard/presentation/views/dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: context.screenHeight,
          width: context.screenWidth,
          child: Lottie.asset(
            MediaRes.robotAnimation,
            fit: BoxFit.contain,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.white.withOpacity(0.8),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (_, state) {
              if (state is AuthError) {
                CoreUtils.showSnackBar(context, state.message);
              } else if (state is SignedUp) {
                context.read<AuthBloc>().add(
                      SignInEvent(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      ),
                    );
              } else if (state is SignedIn) {
                context.userProvider.user = state.user as LocalUserModel;
                Navigator.of(context)
                    .pushReplacementNamed(DashboardScreen.routeName);
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      AppTextCard(
                        text: 'Create your Retro Bank account!',
                        textStyle: context.textTheme.titleLarge!,
                      ),
                      const Gap(10),
                      SignUpForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                        usernameController: usernameController,
                        formKey: formKey,
                      ),
                      const Gap(30),
                      if (state is AuthLoading)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.2,
                          ),
                          child: Lottie.asset(MediaRes.loadingButtonAnimation),
                        )
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.2,
                          ),
                          child: AppTextButton(
                            text: 'Sign up',
                            textStyle: context.textTheme.titleLarge,
                            onPressed: () {
                              debugPrint(
                                FocusManager.instance.primaryFocus == null
                                    ? 'null'
                                    : FocusManager
                                        .instance.primaryFocus?.canRequestFocus
                                        .toString(),
                              );
                              FocusManager.instance.primaryFocus?.unfocus();
                              FirebaseAuth.instance.currentUser?.reload();
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      SignUpEvent(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        username:
                                            usernameController.text.trim(),
                                        photoUrl: 'TEST URL',
                                      ),
                                    );
                              }
                            },
                          ),
                        ),
                      const Gap(20),
                      AppTextButton(
                        shadowColor: Colors.grey[600]!,
                        textColor: Colors.grey[600]!,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignInScreen.routeName);
                        },
                        text: 'Already have an account? Sign in',
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
