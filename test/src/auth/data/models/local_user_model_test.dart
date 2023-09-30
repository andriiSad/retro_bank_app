import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/data/models/credit_card_model.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/auth/domain/entities/local_user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tModel = LocalUserModel.empty();

  final tJson = fixture('local_user.json');

  final tMap = jsonDecode(tJson) as DataMap;

  test(
    'should be subclass of User',
    () {
      // assert
      expect(tModel, isA<LocalUser>());
    },
  );
  group('fromMap', () {
    test(
      'should return a [LocalUserModel] with the right data',
      () {
        // act
        final result = LocalUserModel.fromMap(tMap);

        // assert
        //check is that the result is a [LocalUserModel] not [LocalUser] entity
        expect(result, isA<LocalUserModel>());
        expect(result, tModel);
      },
    );
    //ADDITIONAL TEST
    test(
      'should throw an [Error] when the map is invalid',
      () {
        // arrange
        final map = DataMap.from(tMap)..remove('id');

        // act
        const methodCall = LocalUserModel.fromMap;

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
        // expect(result['id'], tModel.id);
        // expect(result['createdAt'], tModel.createdAt);
        // expect(result['name'], tModel.name);
        // expect(result['avatar'], tModel.avatar);
      },
    );
  });
  group('copyWith', () {
    test('should create a new [LocalUserModel] with updated username', () {
      //arrange
      const updatedUsername = '_updated.username';

      //act
      final updatedModel = tModel.copyWith(username: updatedUsername);

      //expect
      expect(updatedModel, isNot(same(tModel)));
      expect(updatedModel.username, updatedUsername);
      expect(updatedModel.id, tModel.id);
      expect(updatedModel.email, tModel.email);
      expect(updatedModel.cards, tModel.cards);
    });
    test('should create a new [LocalUserModel] with updated cards', () {
      //arrange
      final updatedCards = [CreditCardModel.empty()];

      //act
      final updatedModel = tModel.copyWith(cards: updatedCards);

      //expect
      expect(updatedModel, isNot(same(tModel)));
      expect(updatedModel.cards, updatedCards);
      expect(updatedModel.username, tModel.username);
      expect(updatedModel.id, tModel.id);
      expect(updatedModel.email, tModel.email);
    });
  });
}
