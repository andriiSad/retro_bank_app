import 'package:retro_bank_app/core/utils/typedefs.dart';

// ignore: one_member_abstracts
abstract class ITransactionRepo {
  ResultVoid addTransaction({
    required int amount,
    required int receiverCardId,
    required int senderCardId,
  });
}
