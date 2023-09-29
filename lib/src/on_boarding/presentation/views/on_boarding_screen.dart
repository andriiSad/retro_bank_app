import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retro_bank_app/core/common/views/loading_view.dart';
import 'package:retro_bank_app/core/utils/constants.dart';
import 'package:retro_bank_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/widgets/on_boarding_body.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/on_boarding';

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

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (!isSwiping) {
          isSwiping = true;
          var newIndex = currentIndex;

          if (details.delta.dx > 0 && currentIndex > 0) {
            newIndex = currentIndex - 1;
          } else if (details.delta.dx < 0 &&
              currentIndex < _pageContents.length - 1) {
            newIndex = currentIndex + 1;
          }

          if (newIndex != currentIndex) {
            setState(() {
              currentIndex = newIndex;
            });
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
                title: checkingUserMessage,
              );
            } else if (state is CachingFirstTimer) {
              return const LoadingView(title: cachingMessage);
            } else {
              return Stack(
                children: [
                  OnBoardingBody(
                    content: _pageContents[currentIndex],
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
                      //TODO(remove or find how to remove splash)
                      // onTap: (position) {
                      //   setState(() {
                      //     currentIndex = position;
                      //   });
                      // },
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
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
