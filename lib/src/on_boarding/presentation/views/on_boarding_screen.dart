import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retro_bank_app/core/common/views/loading_view.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/widgets/on_boarding_body.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/on_boarding';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final PageController pageViewController = PageController();

  final List<OnBoardingBody> _onBoardingPages = [
    const OnBoardingBody(
      content: PageContent.first(),
    ),
    const OnBoardingBody(
      content: PageContent.second(),
    ),
    const OnBoardingBody(
      content: PageContent.third(),
    ),
  ];
  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state is UserCached) {
            // Navigator.pushReplacementNamed(context, '/');
            Navigator.pushReplacementNamed(context, '/default');
          }
        },
        builder: (context, state) {
          if (state is CheckingIfUserIsFirstTimer) {
            return const LoadingView(
              title: 'Checking if user is first timer',
            );
          } else if (state is CachingFirstTimer) {
            return const LoadingView(title: 'Caching first timer');
          } else {
            return Stack(
              children: [
                PageView(
                  controller: pageViewController,
                  children: _onBoardingPages,
                ),
                Align(
                  alignment: const Alignment(0, .95),
                  child: SmoothPageIndicator(
                    controller: pageViewController,
                    count: _onBoardingPages.length,
                    onDotClicked: (index) => pageViewController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: Colours.primaryColour,
                      dotColor: Colours.whiteColour,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
