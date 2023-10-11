import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_test/flutter_test.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/transactions/data/models/transaction_model.dart';
import 'package:retro_bank_app/src/transactions/domain/entities/transaction.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tDateTime = DateTime.now();
  final tModel = TransactionModel.empty().copyWith(transactionDate: tDateTime);

  final tJson = fixture('transaction.json');

  final tMap = jsonDecode(tJson) as DataMap;

  test(
    'should be subclass of Transaction',
    () {
      // assert
      expect(tModel, isA<Transaction>());
    },
  );
  group('fromMap', () {
    test(
      'should return a [TransactionModel] with the right data',
      () {
        // act
        final result =
            TransactionModel.fromMap(tMap).copyWith(transactionDate: tDateTime);

        // assert
        //check is that the result is a [TransactionModel]
        //not [Transaction] entity
        expect(result, isA<TransactionModel>());
        expect(result, tModel);
      },
    );
    //ADDITIONAL TEST
    test(
      'should throw an [Error] when the map is invalid',
      () {
        // arrange
        final map = DataMap.from(tMap)..remove('transactionId');

        // act
        const methodCall = TransactionModel.fromMap;

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
        final result = tModel.copyWith(transactionDate: tDateTime).toMap();

        final updatedMap = DataMap.from(result);
        updatedMap['transactionDate'] = firestore.Timestamp.fromDate(tDateTime);

        // assert
        expect(result, updatedMap);
        expect(result['transactionId'], tModel.transactionId);
        expect(result['senderCardId'], tModel.senderCardId);
        expect(result['senderCardOwnerId'], tModel.senderCardOwnerId);
        expect(result['receiverCardId'], tModel.receiverCardId);
        expect(result['receiverCardOwnerId'], tModel.receiverCardOwnerId);
        expect(
          result['transactionDate'],
          firestore.Timestamp.fromDate(tDateTime),
        );
      },
    );
  });
  group('copyWith', () {
    test('should create a new [TransactionModel] with updated amount', () {
      //arrange
      const updatedAmount = 1000;

      //act
      final updatedModel = tModel.copyWith(amount: updatedAmount);

      //expect
      expect(updatedModel, isNot(same(tModel)));
      expect(updatedModel.amount, updatedAmount);
      expect(updatedModel.senderCardId, tModel.senderCardId);
      expect(updatedModel.senderCardOwnerId, tModel.senderCardOwnerId);
      expect(updatedModel.receiverCardId, tModel.receiverCardId);
      expect(updatedModel.receiverCardOwnerId, tModel.receiverCardOwnerId);
    });
  });
  test('toString returns the expected string', () {
    // Define the expected string representation
    final expectedString =
        'TransactionModel(transactionId: ${tModel.transactionId}, '
        'amount: ${tModel.amount}, '
        'receiverCardId: ${tModel.receiverCardId}, '
        'receiverCardOwnerId: ${tModel.receiverCardOwnerId}, '
        'senderCardId: ${tModel.senderCardId}, '
        'senderCardOwnerId: ${tModel.senderCardOwnerId}, '
        'transactionDate: ${tModel.transactionDate})';

    // Verify that the actual toString result matches the expected string
    expect(tModel.toString(), expectedString);
  });
  group('TransactionModel generateNew Test', () {
    test('generateNew creates a new TransactionModel', () {
      // Create a new TransactionModel using the generateNew factory method
      final newTransaction = TransactionModel.generateNew(
        senderCardId: tModel.senderCardId,
        senderCardOwnerId: tModel.senderCardOwnerId,
        receiverCardId: tModel.receiverCardId,
        receiverCardOwnerId: tModel.receiverCardOwnerId,
        amount: tModel.amount,
      );

      // Verify that the newTransaction is an instance of TransactionModel
      expect(newTransaction, isA<TransactionModel>());
    });

    test('generateNew sets the provided data correctly', () {
      // Create a new TransactionModel using the generateNew factory method
      final newTransaction = TransactionModel.generateNew(
        senderCardId: tModel.senderCardId,
        senderCardOwnerId: tModel.senderCardOwnerId,
        receiverCardId: tModel.receiverCardId,
        receiverCardOwnerId: tModel.receiverCardOwnerId,
        amount: tModel.amount,
      );

      // Verify that the newTransaction contains the provided data
      expect(newTransaction.senderCardId, tModel.senderCardId);
      expect(newTransaction.senderCardOwnerId, tModel.senderCardOwnerId);
      expect(newTransaction.receiverCardId, tModel.receiverCardId);
      expect(newTransaction.receiverCardOwnerId, tModel.receiverCardOwnerId);
      expect(newTransaction.amount, tModel.amount);
    });

    test('generateNew generates a unique transactionId', () {
      // Create multiple transactions using generateNew
      final transactions = List.generate(10, (_) {
        return TransactionModel.generateNew(
          senderCardId: tModel.senderCardId,
          senderCardOwnerId: tModel.senderCardOwnerId,
          receiverCardId: tModel.receiverCardId,
          receiverCardOwnerId: tModel.receiverCardOwnerId,
          amount: tModel.amount,
        );
      });

      // Verify that all transactionIds are unique
      final transactionIds = transactions.map((t) => t.transactionId).toSet();
      expect(transactionIds.length, 10);
    });
  });
}
