import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:retro_bank_app/core/common/widgets/gradient_background.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';

class PageUnderConstructionView extends StatelessWidget {
  const PageUnderConstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Lottie.asset(MediaRes.pageUnderConstructionLottie),
        ),
      ),
    );
  }
}
