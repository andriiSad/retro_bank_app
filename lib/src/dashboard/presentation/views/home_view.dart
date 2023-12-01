import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:retro_bank_app/core/common/widgets/gradient_background.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/core/services/injection_container/injection_container.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:retro_bank_app/src/dashboard/presentation/widgets/mono_card_view.dart';
import 'package:retro_bank_app/src/transactions/data/models/transaction_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late int selectedPage;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    selectedPage = 0;
    _pageController = PageController(
      initialPage: selectedPage,
      viewportFraction: 0.85,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
        final cards = context.cardsProvider.cards;
        // final transactions = context.transactionsProvider.transactions;

        return GradientBackground(
          colors: Colours.purplegradient,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 184.h,
                    width: 379.w,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: cards!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: 20.w,
                          ),
                          child: MonoCardView(
                            card: cards[index],
                          ),
                        );
                      },
                    ),
                  ),
                  Gap(22.h),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: cards.length,
                      effect: JumpingDotEffect(
                        spacing: 16.w,
                        dotHeight: 8.h,
                        dotWidth: 8.w,
                        activeDotColor: Colours.white,
                        dotColor: Colours.inactiveDotColor,
                      ),
                    ),
                  ),
                ],
              ),
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
