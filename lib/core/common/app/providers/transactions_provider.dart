import 'package:flutter/foundation.dart';
import 'package:retro_bank_app/src/transactions/domain/entities/transaction.dart';

class TransactionsProvider extends ChangeNotifier {
  List<Transaction>? _transactions;

  List<Transaction>? get transactions => _transactions;

  set transactions(List<Transaction>? transactions) {
    if (!listEquals(_transactions, transactions)) {
      _transactions = transactions;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  // void initCards(List<CreditCardModel>? cards) {
  //   if (_cards != cards) _cards = cards;
  // }
}
