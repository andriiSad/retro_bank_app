import 'package:flutter_test/flutter_test.dart';
import 'package:retro_bank_app/core/enums/credit_card_type.dart';
import 'package:retro_bank_app/core/extensions/credit_card_extension.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

void main() {
  group('CreditCardTypeExtension', () {
    test('toStringValue should return "Premium" for CreditCardType.premium',
        () {
      expect(CreditCardType.premium.toStringValue(), 'Premium');
    });

    test('toStringValue should return "Platinum" for CreditCardType.platinum',
        () {
      expect(CreditCardType.platinum.toStringValue(), 'Platinum');
    });
  });

  group('CreditCardListExtensions', () {
    test('totalBalance should return 0 for an empty list of credit cards', () {
      final emptyList = <CreditCard>[];
      expect(emptyList.totalBalance, 0);
    });

    test(
        'totalBalance should correctly calculate the total balance '
        'for a list of credit cards', () {
      final tCard = CreditCard.empty();
      final cards = <CreditCard>[
        CreditCard(
          cardId: tCard.cardId,
          ownerId: tCard.ownerId,
          type: tCard.type,
          balance: 100,
        ),
        CreditCard(
          cardId: tCard.cardId,
          ownerId: tCard.ownerId,
          type: tCard.type,
          balance: 200,
        ),
        CreditCard(
          cardId: tCard.cardId,
          ownerId: tCard.ownerId,
          type: tCard.type,
          balance: 300,
        ),
      ];
      expect(cards.totalBalance, 600); // 100 + 200 + 300 = 600
    });
  });
  group('CreditCardModelListExtensions', () {
    test(
        'totalBalance should return 0 for an empty list of credit cards models',
        () {
      final emptyList = <CreditCardModel>[];
      expect(emptyList.totalBalance, 0);
    });

    test(
        'totalBalance should correctly calculate the total balance '
        'for a list of credit cards', () {
      final cards = <CreditCardModel>[
        CreditCardModel.empty().copyWith(balance: 100),
        CreditCardModel.empty().copyWith(balance: 200),
        CreditCardModel.empty().copyWith(balance: 300),
      ];
      expect(cards.totalBalance, 600); // 100 + 200 + 300 = 600
    });
  });
}
