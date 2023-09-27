import 'package:flutter/material.dart';
import 'package:retro_bank_app/src/on_boarding/domain/entities/page_content.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    required this.content,
    super.key,
  });

  final PageContent content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          content.title,
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          content.description,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
