import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:retro_bank_app/core/common/app/providers/theme_mode_provider.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_button.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/widgets/combined_image.dart';

class OnBoardingBody extends StatefulWidget {
  const OnBoardingBody({
    required this.content,
    required this.currentIndex,
    super.key,
  });

  final PageContent content;
  final int currentIndex;

  @override
  State<OnBoardingBody> createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<OnBoardingBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        key: ValueKey<int>(
          widget.content.hashCode,
        ),
        children: [
          Stack(
            children: [
              SizedBox(
                height: context.screenHeight,
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  child: CombinedImage(
                    topImagePath: widget.content.topImagePath,
                    bottomImagePath: widget.content.bottomImagePath,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Consumer<ThemeModeProvider>(
                  builder: (context, themeProvider, child) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeTransition(
                            opacity: animationController,
                            child: Text(
                              widget.content.title,
                              key: const ValueKey<String>('title'),
                              style: context.textTheme.titleLarge!
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const Gap(5),
                          FadeTransition(
                            opacity: animationController,
                            child: Text(
                              widget.content.description,
                              key: const ValueKey<String>('description'),
                              style: context.textTheme.bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          if (widget.currentIndex == 2)
                            Align(
                              alignment: Alignment.centerRight,
                              child: AppTextButton(
                                text: 'Get started',
                                onPressed: () {
                                  context
                                      .read<OnBoardingCubit>()
                                      .cacheFirstTimer();
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
