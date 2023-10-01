import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/usecases/usecases.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  const SignUp(this._repository);

  final IAuthRepo _repository;

  @override
  ResultVoid call(SignUpParams params) async => _repository.signUp(
        email: params.email,
        password: params.password,
        username: params.username,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.username,
  });

  factory SignUpParams.empty() => const SignUpParams(
        email: '_empty.email',
        password: '_empty.password',
        username: '_empty.username',
      );

  final String email;
  final String password;
  final String username;

  @override
  List<String> get props => [email, password, username];
}
