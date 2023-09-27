import 'package:retro_bank_app/core/utils/typedefs.dart';

abstract class UsecaseWithParams<Type, Params> {
  const UsecaseWithParams();

  ResultFuture<Type> call(Params params);
}

abstract class UsecaseWithOutParams<Type> {
  const UsecaseWithOutParams();

  ResultFuture<Type> call();
}
