import 'package:flutter/foundation.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

class CardsProvider extends ChangeNotifier {
  List<CreditCard>? _cards;

  List<CreditCard>? get cards => _cards;

  //TODO(create extension for deep list Comparasion)
  set cards(List<CreditCard>? cards) {
    if (!listEquals(_cards, cards)) {
      _cards = cards;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  // void initCards(List<CreditCardModel>? cards) {
  //   if (_cards != cards) _cards = cards;
  // }
}
