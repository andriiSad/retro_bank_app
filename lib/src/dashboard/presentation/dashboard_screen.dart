import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:retro_bank_app/core/common/widgets/app_svg_button.dart';
import 'package:retro_bank_app/core/common/widgets/popup_item.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:retro_bank_app/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:retro_bank_app/src/dashboard/presentation/views/edit_profile_view.dart';

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
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppSvgButton(
                            path: user!.photoUrl ?? MediaRes.robotAvatar,
                            onPressed: () {},
                          ),
                          PopupMenuButton(
                            offset: const Offset(0, 50),
                            surfaceTintColor: Colours.whiteColour,
                            icon: const Icon(Icons.more_horiz),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            itemBuilder: (_) => [
                              PopupMenuItem<void>(
                                onTap: () => context.push(
                                  BlocProvider<AuthBloc>(
                                    create: (_) => serviceLocator<AuthBloc>(),
                                    child: const EditProfileView(),
                                  ),
                                ),
                                child: PopupItem(
                                  title: 'Edit Profile',
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colours.neutralTextColour,
                                  ),
                                ),
                              ),
                              PopupMenuItem<void>(
                                onTap: () => context.push(const Placeholder()),
                                child: PopupItem(
                                  title: 'Notification',
                                  icon: Icon(
                                    IconlyLight.notification,
                                    color: Colours.neutralTextColour,
                                  ),
                                ),
                              ),
                              PopupMenuItem<void>(
                                onTap: () => context.push(const Placeholder()),
                                child: PopupItem(
                                  title: 'Help',
                                  icon: Icon(
                                    Icons.help_outline_outlined,
                                    color: Colours.neutralTextColour,
                                  ),
                                ),
                              ),
                              PopupMenuItem<void>(
                                height: 1,
                                padding: EdgeInsets.zero,
                                child: Divider(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                  endIndent: 16,
                                  indent: 16,
                                ),
                              ),
                              PopupMenuItem<void>(
                                onTap: () async {
                                  await serviceLocator<FirebaseAuth>()
                                      .signOut();
                                  if (context.mounted) {
                                    unawaited(
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/',
                                        (route) => false,
                                      ),
                                    );
                                  }
                                },
                                child: const PopupItem(
                                  title: 'Logout',
                                  icon: Icon(
                                    Icons.logout_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hello, ',
                              style: context.textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: user.username,
                              style: context.textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '!',
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
