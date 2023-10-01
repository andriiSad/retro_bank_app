import 'package:retro_bank_app/core/enums/credit_card_type.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

class CreditCardModel extends CreditCard {
  const CreditCardModel({
    required super.cardId,
    required super.ownerId,
    required super.balance,
    required super.type,
  });

  factory CreditCardModel.empty() => const CreditCardModel(
        cardId: '_empty.cardId',
        ownerId: '_empty.ownerId',
        balance: 0,
        type: CreditCardType.premium,
      );
  factory CreditCardModel.generateNew({
    required String cardId,
    required String ownerId,
  }) =>
      CreditCardModel(
        cardId: cardId,
        ownerId: ownerId,
        balance: 10000,
        type: CreditCardType.premium,
      );

  factory CreditCardModel.fromMap(DataMap map) => CreditCardModel(
        cardId: map['cardId'] as String,
        ownerId: map['ownerId'] as String,
        balance: map['balance'] as int,
        type: CreditCardType.values[map['type'] as int],
      );

  DataMap toMap() => {
        'cardId': cardId,
        'ownerId': ownerId,
        'balance': balance,
        'type': type.index,
      };

  CreditCardModel copyWith({
    String? cardId,
    String? ownerId,
    int? balance,
    CreditCardType? type,
  }) {
    return CreditCardModel(
      cardId: cardId ?? this.cardId,
      ownerId: ownerId ?? this.ownerId,
      balance: balance ?? this.balance,
      type: type ?? this.type,
    );
  }
}
