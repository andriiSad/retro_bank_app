import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:retro_bank_app/core/common/widgets/app_svg_button.dart';
import 'package:retro_bank_app/core/common/widgets/popup_item.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/extensions/credit_card_extension.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:retro_bank_app/src/dashboard/presentation/views/card_view.dart';
import 'package:retro_bank_app/src/dashboard/presentation/views/help_view.dart';
import 'package:retro_bank_app/src/dashboard/presentation/views/notifications_view.dart';
import 'package:retro_bank_app/src/dashboard/providers/dashboard_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
      stream: DashBoardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          // context.userProvider.user = snapshot.data;
          context.userProvider.user = LocalUserModel.empty();
        }
        final user = context.userProvider.user;
        return StreamBuilder<List<CreditCardModel>>(
          stream: DashBoardUtils.creditCardsStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              // context.cardsProvider.cards = snapshot.data;
              context.cardsProvider.cards = [
                CreditCardModel.empty(),
                CreditCardModel.empty(),
              ];
            }
            final cards = context.cardsProvider.cards;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      const Gap(5),
                      SizedBox(
                        width: context.screenWidth * 0.5,
                        child: Text(
                          user.username,
                          maxLines: 1,
                          style: context.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                context.push(const NotificationsView()),
                            icon: const Icon(Icons.notifications_outlined),
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
                                onTap: () => context.push(const HelpView()),
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
                    ],
                  ),
                  const Gap(20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Total balance:',
                          style: context.textTheme.titleLarge,
                        ),
                        Text(
                          '\$${cards!.totalBalance}',
                          style: context.textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  SizedBox(
                    height: 200, // Adjust the height as needed
                    child: PageView.builder(
                      itemCount: cards.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: CardView(card: cards[index]),
                        );
                      },
                    ),
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transactions',
                        style: context.textTheme.titleLarge,
                      ),
                      Consumer<DashboardController>(
                        builder: (_, controller, __) => TextButton(
                          child: Text(
                            'See all',
                            style: context.textTheme.bodyMedium,
                          ),
                          onPressed: () {
                            controller.changeIndex(2);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
