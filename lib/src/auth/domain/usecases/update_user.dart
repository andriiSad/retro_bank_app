import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/enums/update_user_action.dart';
import 'package:retro_bank_app/core/usecases/usecases.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._repository);

  final IAuthRepo _repository;

  @override
  ResultVoid call(
    UpdateUserParams params,
  ) async =>
      _repository.updateUser(
        userData: params.userData,
        action: params.action,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.userData,
    required this.action,
  });

  factory UpdateUserParams.empty() => const UpdateUserParams(
        userData: '_empty.userData',
        action: UpdateUserAction.username,
      );

  final dynamic userData;
  final UpdateUserAction action;

  @override
  List<Object?> get props => [userData, action];
}
