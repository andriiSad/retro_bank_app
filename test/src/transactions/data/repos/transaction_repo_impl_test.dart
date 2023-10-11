import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:retro_bank_app/src/transactions/data/repos/transactions_repo_impl.dart';
import 'package:retro_bank_app/src/transactions/domain/usecases/add_transaction.dart';

import 'transaction_remote_datasource.mock.dart';

void main() {
  late ITransactionsRemoteDataSource remoteDataSource;
  late TransactionsRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockTransactionsRemoteDataSource();
    repoImpl = TransactionsRepoImpl(remoteDataSource);
  });

  group('addTransaction', () {
    final params = AddTransactionParams.empty();
    const tException = ServerException(
      message: 'Unknown error occurred',
      statusCode: '500',
    );
    test(
      'should call the [RemoteDataSource.signIn] and return '
      '[void], when the call to remote source is successful',
      () async {
        //arrange
        when(
          () => remoteDataSource.addTransaction(
            amount: any(named: 'amount'),
            receiverCardId: any(named: 'receiverCardId'),
            senderCardId: any(named: 'senderCardId'),
          ),
        ).thenAnswer((_) async {});

        //act
        final result = await repoImpl.addTransaction(
          amount: params.amount,
          receiverCardId: params.receiverCardId,
          senderCardId: params.senderCardId,
        );

        //assert
        expect(result, const Right<dynamic, void>(null));

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.addTransaction(
            amount: params.amount,
            receiverCardId: params.receiverCardId,
            senderCardId: params.senderCardId,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [ServerFailure] '
      'when the call to remote source is unsuccessful',
      () async {
        //arrange
        when(
          () => remoteDataSource.addTransaction(
            amount: any(named: 'amount'),
            receiverCardId: any(named: 'receiverCardId'),
            senderCardId: any(named: 'senderCardId'),
          ),
        ).thenThrow(tException);

        //act
        final result = await repoImpl.addTransaction(
          amount: params.amount,
          receiverCardId: params.receiverCardId,
          senderCardId: params.senderCardId,
        );

        //assert
        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure.fromException(
              tException,
            ),
          ),
        );

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.addTransaction(
            amount: params.amount,
            receiverCardId: params.receiverCardId,
            senderCardId: params.senderCardId,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
