import 'package:retro_bank_app/core/usecases/usecases.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/transactions/domain/repos/transaction_repo.dart';

class AddTransaction extends UsecaseWithParams<void, AddTransactionParams> {
  const AddTransaction(this._repository);

  final ITransactionRepo _repository;

  @override
  ResultVoid call(AddTransactionParams params) async =>
      _repository.addTransaction(
        amount: params.amount,
        receiverCardId: params.receiverCardId,
        senderCardId: params.senderCardId,
      );
}

class AddTransactionParams {
  const AddTransactionParams({
    required this.amount,
    required this.receiverCardId,
    required this.senderCardId,
  });

  factory AddTransactionParams.empty() => const AddTransactionParams(
        amount: 0,
        receiverCardId: 0,
        senderCardId: 0,
      );

  final int amount;
  final int receiverCardId;
  final int senderCardId;
}
