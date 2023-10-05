import 'package:flutter/material.dart';

class AppTextCard extends StatelessWidget {
  const AppTextCard({
    required this.text,
    required this.textStyle,
    this.textColor = Colors.black,
    super.key,
    this.backGroundColor = Colors.white,
  });

  final String text;
  final Color backGroundColor;
  final TextStyle textStyle;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: backGroundColor.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
