import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/transactions/domain/repos/transaction_repo.dart';
import 'package:retro_bank_app/src/transactions/domain/usecases/add_transaction.dart';

import 'transaction_repo_mock.dart';

void main() {
  late ITransactionRepo repository;
  late AddTransaction usecase;

  const tFailure = ServerFailure(
    message: 'Server Failure',
    statusCode: 500,
  );
  final params = AddTransactionParams.empty();

  setUp(() {
    repository = MockTransactionRepo();
    usecase = AddTransaction(repository);
  });

  group('AddTransaction', () {
    test(
      'should call the [TransactionRepo.addTransaction] '
      'and return [void] if successfull',
      () async {
        // arrange
        when(
          () => repository.addTransaction(
            amount: any(named: 'amount'),
            receiverCardId: any(named: 'receiverCardId'),
            senderCardId: any(named: 'senderCardId'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await usecase(params);

        // assert
        expect(result, const Right<dynamic, void>(null));

        verify(
          () => repository.addTransaction(
            amount: params.amount,
            receiverCardId: params.receiverCardId,
            senderCardId: params.senderCardId,
          ),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
    test(
      'should call the [TransactionRepo.addTransaction] '
      'and return [ServerFailure] if unsuccessfull',
      () async {
        // arrange
        when(
          () => repository.addTransaction(
            amount: any(named: 'amount'),
            receiverCardId: any(named: 'receiverCardId'),
            senderCardId: any(named: 'senderCardId'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(params);

        // assert
        expect(result, const Left<Failure, dynamic>(tFailure));

        verify(
          () => repository.addTransaction(
            amount: params.amount,
            receiverCardId: params.receiverCardId,
            senderCardId: params.senderCardId,
          ),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
  });
}
