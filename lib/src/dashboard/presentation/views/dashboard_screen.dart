import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retro_bank_app/core/res/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // final user = context.userProvider.user;
    return Scaffold(
      backgroundColor: Colours.whiteColour,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20),
            Text(
              // 'Hello ${user?.fullName}!',
              'Hello user!',
              style: TextStyle(fontSize: 20),
            ),
            Gap(20),
            // BlocListener<AuthBloc, AuthState>(
            //   listener: (context, state) {
            //     if (state is UserSignedOut) {
            //       Navigator.of(context)
            //           .pushReplacementNamed(SignInScreen.routeName);
            //     }
            //   },
            //   child: RoundedButton(
            //     label: 'Log out',
            //     onPressed: () {
            //       context.read<AuthBloc>().add(SignOutEvent());
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
