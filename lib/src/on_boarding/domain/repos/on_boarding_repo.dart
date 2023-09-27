import 'package:retro_bank_app/core/utils/typedefs.dart';

abstract class IOnBoardingRepo {
  ResultVoid cacheFirstTimer();

  ResultFuture<bool> checkIfUserIsFirstTimer();
}
