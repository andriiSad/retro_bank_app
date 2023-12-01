import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/res/colors.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

class MonoCardView extends StatelessWidget {
  const MonoCardView({required this.card, super.key});

  final CreditCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Colours.darkBlueCardGradient,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
    );
  }
}
