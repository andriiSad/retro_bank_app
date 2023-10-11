import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  const Transaction({
    required this.transactionId,
    required this.amount,
    required this.receiverCardId,
    required this.receiverCardOwnerId,
    required this.senderCardId,
    required this.senderCardOwnerId,
    required this.transactionDate,
  });

  final String transactionId;
  final int amount;
  final int receiverCardId;
  final String receiverCardOwnerId;
  final int senderCardId;
  final String senderCardOwnerId;
  final DateTime transactionDate;

  @override
  List<String> get props => [
        transactionId,
      ];
}
