import 'package:dartz/dartz.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:retro_bank_app/src/transactions/domain/repos/transaction_repo.dart';

class TransactionsRepoImpl implements ITransactionRepo {
  const TransactionsRepoImpl(this._remoteDataSource);
  final ITransactionsRemoteDataSource _remoteDataSource;

  @override
  ResultVoid addTransaction({
    required int amount,
    required int receiverCardId,
    required int senderCardId,
  }) async {
    try {
      await _remoteDataSource.addTransaction(
        amount: amount,
        receiverCardId: receiverCardId,
        senderCardId: senderCardId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
