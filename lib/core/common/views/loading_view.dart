import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    //use Material for overlay
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                context.theme.colorScheme.secondary,
              ),
            ),
            const Gap(10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
