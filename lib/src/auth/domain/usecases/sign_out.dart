import 'package:retro_bank_app/core/usecases/usecases.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';

class SignOut extends UsecaseWithOutParams<void> {
  const SignOut(this._repository);

  final IAuthRepo _repository;

  @override
  ResultVoid call() async => _repository.signOut();
}
