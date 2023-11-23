import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
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
import 'package:retro_bank_app/src/dashboard/presentation/views/help_view.dart';
import 'package:retro_bank_app/src/dashboard/presentation/views/notifications_view.dart';
import 'package:retro_bank_app/src/dashboard/presentation/widgets/card_view.dart';
import 'package:retro_bank_app/src/dashboard/presentation/widgets/transactions_list_view.dart';
import 'package:retro_bank_app/src/dashboard/providers/dashboard_controller.dart';
import 'package:retro_bank_app/src/transactions/data/models/transaction_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = serviceLocator<FirebaseAuth>().currentUser!;
    final localUser = LocalUserModel(
      id: user.uid,
      email: user.email!,
      username: user.displayName!,
      photoUrl: user.photoURL,
    );
    context.userProvider.initUser(localUser);
    return StreamBuilder3<LocalUserModel, List<CreditCardModel>,
        List<TransactionModel>>(
      streams: StreamTuple3(
        DashBoardUtils.userDataStream,
        DashBoardUtils.creditCardsStream,
        DashBoardUtils.transactionsStream,
      ),
      builder: (context, snapshots) {
        if (snapshots.snapshot1.connectionState == ConnectionState.waiting ||
            snapshots.snapshot2.connectionState == ConnectionState.waiting ||
            snapshots.snapshot3.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          );
        }
        if (snapshots.snapshot1.hasData) {
          context.userProvider.user = snapshots.snapshot1.data;
        }
        if (snapshots.snapshot2.hasData) {
          context.cardsProvider.cards = snapshots.snapshot2.data;
        }
        if (snapshots.snapshot3.hasData) {
          context.transactionsProvider.transactions = snapshots.snapshot3.data;
        }

        final user = context.userProvider.user;
        final cards = context.cardsProvider.cards;
        final transactions = context.transactionsProvider.transactions;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppSvgButton(
                    path: user!.photoUrl ?? MediaRes.robotAvatar,
                    isNetwork: user.photoUrl != null,
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
                              await serviceLocator<FirebaseAuth>().signOut();
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
                      '\$${cards?.totalBalance}',
                      style: context.textTheme.titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              SizedBox(
                height: 230, // Adjust the height as needed
                child: PageView.builder(
                  itemCount: cards?.length,
                  itemBuilder: (BuildContext context, int index) {
                    final card = cards?[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 1),
                      child: CardView(
                        card: card ?? CreditCardModel.empty(),
                      ),
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
              TransactionsListView(
                transactions: transactions,
              ),
            ],
          ),
        );
      },
    );
  }
}
