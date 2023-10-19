import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/transactions/domain/usecases/add_transaction.dart';
import 'package:retro_bank_app/src/transactions/presentation/bloc/transactions_bloc.dart';

class MockAddTransaction extends Mock implements AddTransaction {}

void main() {
  late AddTransaction addTransaction;

  late TransactionsBloc transactionsBloc;

  final tAddTransactionParams = AddTransactionParams.empty();

  const tFailure = ServerFailure(
    message: 'Unknown failure',
    statusCode: 505,
  );

  setUp(() {
    addTransaction = MockAddTransaction();

    transactionsBloc = TransactionsBloc(
      addTransaction: addTransaction,
    );
    registerFallbackValue(tAddTransactionParams);
  });

  //always close the bloc
  tearDown(() => transactionsBloc.close);

  test(
    'initial state should be [TransactionsInitial]',
    () async => expect(transactionsBloc.state, const TransactionsInitial()),
  );

  group('AddTransactionEvent', () {
    blocTest<TransactionsBloc, TransactionsState>(
      'should emit [TransactionPending, TransactionAdded] '
      'when [SignInEvent] is added',
      build: () {
        when(
          () => addTransaction(
            any(),
          ),
        ).thenAnswer((_) async => const Right(null));
        return transactionsBloc;
      },
      act: (bloc) => bloc.add(
        AddTransactionEvent(
          amount: tAddTransactionParams.amount,
          receiverCardId: tAddTransactionParams.receiverCardId,
          senderCardId: tAddTransactionParams.senderCardId,
        ),
      ),
      expect: () => [
        const TransactionPending(),
        const TransactionAdded(),
      ],
      verify: (_) {
        verify(
          () => addTransaction(
            tAddTransactionParams,
          ),
        ).called(1);

        verifyNoMoreInteractions(addTransaction);
      },
    );
    blocTest<TransactionsBloc, TransactionsState>(
      'should emit [TransactionPending, TransactionsError] '
      'when addTransaction returns a failure',
      build: () {
        when(
          () => addTransaction(
            any(),
          ),
        ).thenAnswer((_) async => const Left(tFailure));
        return transactionsBloc;
      },
      act: (bloc) => bloc.add(
        AddTransactionEvent(
          amount: tAddTransactionParams.amount,
          receiverCardId: tAddTransactionParams.receiverCardId,
          senderCardId: tAddTransactionParams.senderCardId,
        ),
      ),
      expect: () => [
        const TransactionPending(),
        TransactionsError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => addTransaction(
            tAddTransactionParams,
          ),
        ).called(1);

        verifyNoMoreInteractions(addTransaction);
      },
    );
  });
}
