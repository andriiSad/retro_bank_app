import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/usecases/usecases.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, ForgotPasswordParams> {
  const ForgotPassword(this._repository);

  final IAuthRepo _repository;

  @override
  ResultVoid call(
    ForgotPasswordParams params,
  ) async =>
      _repository.forgotPassword(
        email: params.email,
      );
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({
    required this.email,
  });

  const ForgotPasswordParams.empty()
      : this(
          email: '_empty.email',
        );

  final String email;

  @override
  List<String> get props => [email];
}
