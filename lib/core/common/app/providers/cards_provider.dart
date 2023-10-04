import 'package:flutter/foundation.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';

class CardsProvider extends ChangeNotifier {
  List<CreditCardModel>? _cards;

  List<CreditCardModel>? get cards => _cards;

  //TODO(create extension for deep list Comparasion)
  set cards(List<CreditCardModel>? cards) {
    if (!listEquals(_cards, cards)) {
      _cards = cards;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  // void initCards(List<CreditCardModel>? cards) {
  //   if (_cards != cards) _cards = cards;
  // }
}
