import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/transactions/domain/entities/transaction.dart';
import 'package:uuid/uuid.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.transactionId,
    required super.amount,
    required super.receiverCardId,
    required super.receiverCardOwnerId,
    required super.senderCardId,
    required super.senderCardOwnerId,
    required super.transactionDate,
  });

  factory TransactionModel.empty() => TransactionModel(
        transactionId: '_empty.transactionId',
        amount: 0,
        receiverCardId: 0,
        receiverCardOwnerId: '_empty.receiverCardOwnerId',
        senderCardId: 0,
        senderCardOwnerId: '_empty.senderCardOwnerId',
        transactionDate: DateTime.now(),
      );

  factory TransactionModel.generateNew({
    required int senderCardId,
    required String senderCardOwnerId,
    required int receiverCardId,
    required String receiverCardOwnerId,
    required int amount,
  }) =>
      TransactionModel(
        transactionId: const Uuid().v1(),
        amount: amount,
        receiverCardId: receiverCardId,
        receiverCardOwnerId: receiverCardOwnerId,
        senderCardId: senderCardId,
        senderCardOwnerId: senderCardOwnerId,
        transactionDate: DateTime.now(),
      );

  factory TransactionModel.fromMap(DataMap map) {
    return TransactionModel(
      transactionId: map['transactionId'] as String,
      amount: map['amount'] as int,
      receiverCardId: map['receiverCardId'] as int,
      receiverCardOwnerId: map['receiverCardOwnerId'] as String,
      senderCardId: map['senderCardId'] as int,
      senderCardOwnerId: map['senderCardOwnerId'] as String,
      transactionDate: (map['transactionDate'] as firestore.Timestamp).toDate(),
    );
  }

  DataMap toMap() => {
        'transactionId': transactionId,
        'amount': amount,
        'receiverCardId': receiverCardId,
        'receiverCardOwnerId': receiverCardOwnerId,
        'senderCardId': senderCardId,
        'senderCardOwnerId': senderCardOwnerId,
        'transactionDate': firestore.Timestamp.fromDate(transactionDate),
      };

  TransactionModel copyWith({
    String? transactionId,
    int? amount,
    int? receiverCardId,
    String? receiverCardOwnerId,
    int? senderCardId,
    String? senderCardOwnerId,
    DateTime? transactionDate,
  }) {
    return TransactionModel(
      transactionId: transactionId ?? this.transactionId,
      amount: amount ?? this.amount,
      receiverCardId: receiverCardId ?? this.receiverCardId,
      receiverCardOwnerId: receiverCardOwnerId ?? this.receiverCardOwnerId,
      senderCardId: senderCardId ?? this.senderCardId,
      senderCardOwnerId: senderCardOwnerId ?? this.senderCardOwnerId,
      transactionDate: transactionDate ?? this.transactionDate,
    );
  }

  @override
  List<Object?> get props => [
        transactionId,
        amount,
        receiverCardId,
        receiverCardOwnerId,
        senderCardId,
        senderCardOwnerId,
        transactionDate,
      ];

  @override
  String toString() => '$TransactionModel(transactionId: $transactionId, '
      'amount: $amount, '
      'receiverCardId: $receiverCardId, '
      'receiverCardOwnerId: $receiverCardOwnerId, '
      'senderCardId: $senderCardId, '
      'senderCardOwnerId: $senderCardOwnerId, '
      'transactionDate: $transactionDate)';
}
