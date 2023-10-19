part of 'transactions_bloc.dart';

sealed class TransactionsEvent {
  const TransactionsEvent();
}

class AddTransactionEvent extends TransactionsEvent {
  const AddTransactionEvent({
    required this.amount,
    required this.receiverCardId,
    required this.senderCardId,
  });

  final int amount;
  final int receiverCardId;
  final int senderCardId;
}
