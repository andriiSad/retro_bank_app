import 'package:retro_bank_app/core/enums/credit_card_type.dart';
import 'package:retro_bank_app/core/services/cvv_service/cvv_service.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

class CreditCardModel extends CreditCard {
  const CreditCardModel({
    required super.cardId,
    required super.ownerId,
    required super.balance,
    required super.type,
    required super.cvv,
  });

  factory CreditCardModel.fromMap(DataMap map) => CreditCardModel(
        cardId: map['cardId'] as String,
        ownerId: map['ownerId'] as String,
        balance: map['balance'] as int,
        type: CreditCardType.values[map['type'] as int],
        cvv: CvvService.decrypt(map['cvv'] as String), // Set the decrypted CVV
      );

  factory CreditCardModel.empty() => const CreditCardModel(
        cardId: '_empty.cardId',
        ownerId: '_empty.ownerId',
        balance: 0,
        type: CreditCardType.premium,
        cvv: '_empty.cvv',
      );

  DataMap toMap() {
    return {
      'cardId': cardId,
      'ownerId': ownerId,
      'balance': balance,
      'type': type.index,
      'cvv': CvvService.encrypt(cvv),
    };
  }

  CreditCardModel copyWith({
    String? cardId,
    String? ownerId,
    int? balance,
    CreditCardType? type,
    String? cvv,
  }) {
    return CreditCardModel(
      cardId: cardId ?? this.cardId,
      ownerId: ownerId ?? this.ownerId,
      balance: balance ?? this.balance,
      type: type ?? this.type,
      cvv: cvv ?? this.cvv,
    );
  }

  @override
  String toString() => '$CreditCardModel(cardId: $cardId, ownerId: $ownerId, '
      'balance: $balance, type: $type, cvv: $cvv)';
}
