import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/src/transactions/domain/usecases/add_transaction.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required AddTransaction addTransaction,
  })  : _addTransaction = addTransaction,
        super(const TransactionsInitial()) {
    on<AddTransactionEvent>(_addTransactionHandler);
  }

  final AddTransaction _addTransaction;

  Future<void> _addTransactionHandler(
    AddTransactionEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(const TransactionPending());

    final result = await _addTransaction(
      AddTransactionParams(
        amount: event.amount,
        receiverCardId: event.receiverCardId,
        senderCardId: event.senderCardId,
      ),
    );
    result.fold(
      (failure) => emit(TransactionsError(failure.errorMessage)),
      (_) => emit(const TransactionAdded()),
    );
  }
}
