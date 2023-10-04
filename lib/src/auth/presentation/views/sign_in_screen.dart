import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:retro_bank_app/core/common/widgets/app_svg_button.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_button.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/core/res/fonts.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
import 'package:retro_bank_app/core/utils/core_utils.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:retro_bank_app/src/auth/presentation/views/sign_up_screen.dart';
import 'package:retro_bank_app/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:retro_bank_app/src/dashboard/presentation/views/dashboard_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign_in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.whiteColour,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
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
                  const Text(
                    'Welcome Back to Retro Bank!',
                    style: TextStyle(
                      fontFamily: Fonts.aeonik,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppSvgButton(
                          assetPath: MediaRes.appleSignInImage,
                          onPressed: () {},
                        ),
                        AppSvgButton(
                          assetPath: MediaRes.googleSignInImage,
                          onPressed: () {},
                        ),
                        AppSvgButton(
                          assetPath: MediaRes.facebookSignInImage,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Gap(30),
                  SignInForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    formKey: formKey,
                  ),
                  const Gap(20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppTextButton(
                      shadowColor: Colors.grey[600]!,
                      textColor: Colors.grey[600]!,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/forgot_password');
                      },
                      text: 'Forgot password',
                    ),
                  ),
                  const Gap(30),
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.2,
                      ),
                      child: AppTextButton(
                        text: 'Sign in',
                        textStyle: context.textTheme.titleLarge,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignInEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
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
                          .pushReplacementNamed(SignUpScreen.routeName);
                    },
                    text: "New to Retro Bank? Let's Begin!",
                  ),
                  const Gap(20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
