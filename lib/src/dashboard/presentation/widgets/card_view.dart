import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/enums/credit_card_type.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';
import 'package:retro_bank_app/core/res/media_resources.dart';
import 'package:retro_bank_app/core/utils/core_utils.dart';
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

class CardViewState extends State<CardView> with TickerProviderStateMixin {
  bool isFlipped = false;

  final flipDuration = 500;

  late AnimationController _flipController;
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: flipDuration,
      ),
    );
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );

    _opacityAnimation =
        Tween<double>(begin: 0, end: 1).animate(_opacityController);
  }

  void _toggleCard() {
    if (_flipController.value == 0 || _flipController.value == 1) {
      _opacityController.value = 0;
      _flipController.value == 0
          ? _flipController.forward()
          : _flipController.reverse();
      Future.delayed(Duration(milliseconds: flipDuration ~/ 2), () {
        if (mounted) {
          setState(() {
            isFlipped = !isFlipped;
          });
        }
      });
    }
  }

  void showInfoBanner() {
    if (_opacityController.value == 0) {
      _opacityController.forward();
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _opacityController.reverse();
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlatinum = widget.card.type == CreditCardType.platinum;

    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _flipController,
        builder: (BuildContext context, Widget? child) {
          final valueY = 180 * _flipController.value;
          final valueX = 360 * _flipController.value;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(valueY * 3.14159265359 / 180)
              ..rotateX(valueX * 3.14159265359 / 180),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Container(
                width: context.screenWidth * 0.9,
                height: context.screenHeight * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.8),
                      BlendMode.srcOver,
                    ),
                    image: AssetImage(
                      isPlatinum
                          ? MediaRes.onBoardingImageSix
                          : MediaRes.onBoardingImageOne,
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
                        child: _BackCardInfo(
                          cvv: widget.card.cvv,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 70,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: FadeTransition(
                                      opacity: _opacityAnimation,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                          top: 5,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 5,
                                            ),
                                            child: isPlatinum
                                                ? const Text(
                                                    'This is Platinum card, '
                                                    'any transactions with '
                                                    '0% commision',
                                                  )
                                                : const Text(
                                                    'This is Premium card, '
                                                    'any transactions with '
                                                    '5% commision',
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 30,
                                    onPressed: showInfoBanner,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: isPlatinum
                                        ? const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          )
                                        : const Icon(
                                            Icons.info_outline,
                                            color: Colors.black,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 5,
                              ),
                              child: Text(
                                '\$${widget.card.balance}',
                                style: context.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              FlutterClipboard.copy(widget.card.cardId).then(
                                (value) => CoreUtils.showSnackBar(
                                  context,
                                  'Card number successfully copied!',
                                ),
                              );
                            },
                            child: Text(
                              '**** **** **** ${widget.card.cardId}',
                              style: context.textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BackCardInfo extends StatelessWidget {
  const _BackCardInfo({required this.cvv});

  final String cvv;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Align(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onLongPress: () {
                  FlutterClipboard.copy(cvv).then(
                    (value) => CoreUtils.showSnackBar(
                      context,
                      'CVV successfully copied!',
                    ),
                  );
                },
                child: Text(
                  'CVV: $cvv  ',
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
