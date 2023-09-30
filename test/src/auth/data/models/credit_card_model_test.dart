import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/domain/entities/credit_card.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tModel = CreditCardModel.empty();

  final tJson = fixture('credit_card.json');

  final tMap = jsonDecode(tJson) as DataMap;

  test('should be a subclass of CreditCard', () {
    expect(tModel, isA<CreditCard>());
  });

  group('fromMap', () {
    test(
      'should return a [CreditCardModel] with the right data',
      () {
        // act
        final result = CreditCardModel.fromMap(tMap);

        // assert
        //check is that the result is a [CreditCardModel] not [CreditCard]
        expect(result, tModel);
      },
    );
    //ADDITIONAL TEST
    test(
      'should throw an [Error] when the map is invalid',
      () {
        // arrange
        final map = DataMap.from(tMap)..remove('cardId');

        // act
        const methodCall = CreditCardModel.fromMap;

        // assert
        expect(() => methodCall(map), throwsA(isA<Error>()));
      },
    );
  });

  group('toMap', () {
    test(
      'should return a valid DataMap',
      () {
        // act
        final result = tModel.toMap();

        // assert
        expect(result, tMap);
      },
    );
  });

  group('copyWith', () {
    test('should create a new [LocalUserModel] with updated balance', () {
      //arrange
      const updatedBalance = 9999;

      //act
      final updatedModel = tModel.copyWith(balance: updatedBalance);

      //expect
      expect(updatedModel, isNot(same(tModel)));
      expect(updatedModel.balance, updatedBalance);
      expect(updatedModel.cardId, tModel.cardId);
      expect(updatedModel.ownerId, tModel.ownerId);
      expect(updatedModel.type, tModel.type);
    });
    test('should create a new [LocalUserModel] with updated username', () {
      //arrange
      const updatedCardId = '_updated.cardId';

      //act
      final updatedModel = tModel.copyWith(cardId: updatedCardId);

      //expect
      expect(updatedModel, isNot(same(tModel)));
      expect(updatedModel.cardId, updatedCardId);
      expect(updatedModel.balance, tModel.balance);
      expect(updatedModel.ownerId, tModel.ownerId);
      expect(updatedModel.type, tModel.type);
    });
  });
}
