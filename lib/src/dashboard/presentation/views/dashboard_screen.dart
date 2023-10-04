import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:retro_bank_app/core/common/widgets/rounded_button.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:retro_bank_app/src/auth/presentation/views/sign_in_screen.dart';
import 'package:retro_bank_app/src/dashboard/presentation/utils/dashboard_utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
      stream: DashBoardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          context.userProvider.user = snapshot.data;
        }
        final user = context.userProvider.user;
        return StreamBuilder<List<CreditCardModel>>(
          stream: DashBoardUtils.creditCardsStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              context.cardsProvider.cards = snapshot.data;
            }
            final cards = context.cardsProvider.cards;
            return Scaffold(
              backgroundColor: Colours.whiteColour,
              appBar: AppBar(
                title: const Text('Dashboard'),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    Text(
                      'Hello $user',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      cards![0].balance.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Gap(20),
                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is UserSignedOut) {
                          Navigator.of(context)
                              .pushReplacementNamed(SignInScreen.routeName);
                        }
                      },
                      child: RoundedButton(
                        label: 'Log out',
                        onPressed: () {
                          context.read<AuthBloc>().add(SignOutEvent());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
