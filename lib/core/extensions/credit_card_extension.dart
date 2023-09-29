import 'package:retro_bank_app/core/enums/credit_card_type.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

extension CreditCardTypeExtension on CreditCardType {
  String toStringValue() {
    switch (this) {
      case CreditCardType.premium:
        return 'Premium';
      case CreditCardType.platinum:
        return 'Platinum';
    }
  }
}

extension CreditCardListExtensions on List<CreditCard> {
  int get totalBalance {
    return fold(0, (total, card) => total + card.balance);
  }
}
