import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/enums/credit_card_type.dart';

class CreditCard extends Equatable {
  const CreditCard({
    required this.cardId,
    required this.ownerId,
    required this.balance,
    required this.type,
  });

  factory CreditCard.empty() {
    return const CreditCard(
      cardId: '_empty.cardId',
      ownerId: '_empty.ownerId',
      balance: 0,
      type: CreditCardType.premium,
    );
  }

  CreditCard copyWith({
    String? cardId,
    String? ownerId,
    int? balance,
    CreditCardType? type,
  }) {
    return CreditCard(
      cardId: cardId ?? this.cardId,
      ownerId: ownerId ?? this.ownerId,
      balance: balance ?? this.balance,
      type: type ?? this.type,
    );
  }

  final String cardId;
  final String ownerId;
  final CreditCardType type;
  final int balance;

  @override
  List<Object?> get props => [cardId, ownerId, balance, type];

  @override
  String toString() {
    return 'CreditCard(cardId: $cardId, ownerId: $ownerId, '
        'balance: $balance, type: $type)';
  }
}
