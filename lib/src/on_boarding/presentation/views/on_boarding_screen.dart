import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retro_bank_app/core/common/views/loading_view.dart';
import 'package:retro_bank_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/widgets/on_boarding_body.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/on_boarding';
  static const double swipeThreshold = 100;

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  final List<PageContent> _pageContents = [
    const PageContent.first(),
    const PageContent.second(),
    const PageContent.third(),
  ];
  late int currentIndex;
  bool isSwiping = false; // Flag to control swiping direction
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (!isSwiping) {
          isSwiping = true;
          if (details.delta.dx > 0) {
            if (currentIndex > 0) {
              _animationController.forward();
              setState(() {
                currentIndex = currentIndex - 1;
              });
            }
          }
          if (details.delta.dx < 0) {
            if (currentIndex < _pageContents.length - 1) {
              _animationController.forward();

              setState(() {
                currentIndex = currentIndex + 1;
              });
            }
          }
        }
      },
      onPanEnd: (_) {
        isSwiping = false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
          listener: (context, state) {
            if (state is UserCached) {
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
                  OnBoardingBody(
                    content: _pageContents[currentIndex],
                    animation: _animationController,
                    currentIndex: currentIndex,
                  ),
                  Align(
                    alignment: const Alignment(0, .5),
                    child: DotsIndicator(
                      dotsCount: _pageContents.length,
                      position: currentIndex,
                      decorator: DotsDecorator(
                        spacing: const EdgeInsets.all(10),
                        activeSize: const Size(18, 9),
                        activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        activeColor: Colors.white,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 7,
                              ),
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  color: Colors.white,
                                ), // Text color
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
