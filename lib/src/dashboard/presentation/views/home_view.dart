import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:retro_bank_app/core/common/widgets/gradient_background.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/dashboard/presentation/utils/dashboard_utils.dart';
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

        // final user = context.userProvider.user;
        // final cards = context.cardsProvider.cards;
        // final transactions = context.transactionsProvider.transactions;

        return GradientBackground(
          colors: Colours.purplegradient,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                height: 340.h,
                decoration: BoxDecoration(
                  color: Colours.transactionsBackgroundColor,
                  borderRadius: const BorderRadiusDirectional.vertical(
                    top: Radius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
