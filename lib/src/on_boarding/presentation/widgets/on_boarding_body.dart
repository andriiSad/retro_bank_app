import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:retro_bank_app/core/common/app/providers/theme_mode_provider.dart';
import 'package:retro_bank_app/core/common/widgets/app_text_button.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/src/on_boarding/domain/entities/page_content.dart';
import 'package:retro_bank_app/src/on_boarding/presentation/widgets/combined_image.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    required this.content,
    required this.animation,
    required this.currentIndex,
    super.key,
  });

  final PageContent content;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          key: ValueKey<int>(
            content.hashCode,
          ),
          children: [
            Stack(
              children: [
                SizedBox(
                  height: context.screenHeight * 0.85,
                  child: ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds);
                    },
                    child: CombinedImage(
                      topImagePath: content.topImagePath,
                      bottomImagePath: content.bottomImagePath,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Consumer<ThemeModeProvider>(
                    builder: (context, themeProvider, child) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeTransition(
                            opacity: animation,
                            child: Text(
                              content.title,
                              key: const ValueKey<String>('title'),
                              style: context.textTheme.titleLarge!
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const Gap(5),
                          FadeTransition(
                            opacity: animation,
                            child: Text(
                              content.description,
                              key: const ValueKey<String>('description'),
                              style: context.textTheme.bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          if (currentIndex == 2)
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: AppTextButton(
                                    text: 'Get started',
                                    textStyle: context.textTheme.bodyMedium!,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
