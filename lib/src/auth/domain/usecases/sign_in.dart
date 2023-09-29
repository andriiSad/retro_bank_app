import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/usecases/usecases.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/entities/local_user.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';

class SignIn extends UsecaseWithParams<LocalUser, SignInParams> {
  const SignIn(this._repository);

  final IAuthRepo _repository;

  @override
  ResultFuture<LocalUser> call(SignInParams params) async => _repository.signIn(
        email: params.email,
        password: params.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.email,
    required this.password,
  });

  const SignInParams.empty()
      : this(
          email: '_empty.email',
          password: '_empty.password',
        );

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
