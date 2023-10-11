import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

class CardView extends StatefulWidget {
  const CardView({
    required this.card,
    super.key,
  });

  final CreditCard card;

  @override
  CardViewState createState() => CardViewState();
}

class CardViewState extends State<CardView> {
  bool isFlipped = false;

  void _toggleCard() {
    setState(() {
      isFlipped = !isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: Tween<double>(
          begin: 0,
          end: isFlipped ? 180 : 0,
        ).animate(
          CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeInOut,
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          final value = isFlipped ? 180 : 0;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * 3.14159265359 / 180),
            alignment: Alignment.center,
            child: Container(
              width: context.screenWidth * 0.9,
              height: context.screenHeight * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 2,
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.9),
                    BlendMode.srcOver,
                  ),
                  image: const AssetImage(
                    MediaRes.onBoardingImageSix,
                  ),
                ),
              ),
              child: isFlipped
                  ? Transform(
                      // Apply the rotation only to the back card content
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(3.14159265359), // 180 degrees
                      alignment: Alignment.center,
                      child: const _BackCardInfo(),
                    )
                  : null, // Show back card when flipped
            ),
          );
        },
      ),
    );
  }
}

class _BackCardInfo extends StatelessWidget {
  const _BackCardInfo();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.9),
                BlendMode.srcOver,
              ),
              image: const AssetImage(
                MediaRes.onBoardingImageFive,
              ),
            ),
          ),
        ),
        Align(
          child: Container(
            height: 40,
            width: double.infinity,
            color: Colors.black.withOpacity(0.4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 60,
                  top: 4,
                  bottom: 4,
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'CVV: 234  ',
                      style: context.textTheme.bodyMedium,
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
}
