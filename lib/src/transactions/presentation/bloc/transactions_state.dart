part of 'transactions_bloc.dart';

sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

final class TransactionPending extends TransactionsState {
  const TransactionPending();
}

final class TransactionAdded extends TransactionsState {
  const TransactionAdded();
}

class TransactionsError extends TransactionsState {
  const TransactionsError(
    this.message,
  );
  final String message;

  @override
  List<String> get props => [message];
}
