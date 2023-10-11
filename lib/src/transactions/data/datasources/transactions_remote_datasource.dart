// ignore: one_member_abstracts
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/src/transactions/data/models/transaction_model.dart';

// ignore: one_member_abstracts
abstract class ITransactionsRemoteDataSource {
  Future<void> addTransaction({
    required int amount,
    required int receiverCardId,
    required int senderCardId,
  });
}

class TransactionsRemoteDatasourceImpl
    implements ITransactionsRemoteDataSource {
  TransactionsRemoteDatasourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;

  @override
  Future<void> addTransaction({
    required int amount,
    required int receiverCardId,
    required int senderCardId,
  }) async {
    try {
      final senderCardOwnerId = _authClient.currentUser!.uid;
      final receiverCardOwnerId = await _getUserIdByCardId(receiverCardId);

      final transaction = TransactionModel.generateNew(
        senderCardId: senderCardId,
        senderCardOwnerId: senderCardOwnerId,
        receiverCardId: receiverCardId,
        receiverCardOwnerId: receiverCardOwnerId,
        amount: amount,
      );
      await _cloudStoreClient
          .collection('transactions')
          .doc(transaction.transactionId)
          .set(
            transaction.toMap(),
          );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<String> _getUserIdByCardId(int cardId) async {
    try {
      final docSnapshot = await _cloudStoreClient
          .collection('cards')
          .doc(cardId.toString())
          .get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final ownerId = data['ownerId'] as String;
        return ownerId;
      } else {
        // Handle the case where the document doesn't exist
        throw const ServerException(
          message: 'User not found for this card',
          statusCode: '404',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
