import 'package:retro_bank_app/core/enums/update_user_action.dart';
import 'package:retro_bank_app/core/utils/typedefs.dart';
import 'package:retro_bank_app/src/auth/domain/entities/local_user.dart';

abstract class IAuthRepo {
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultVoid signUp({
    required String email,
    required String password,
    required String username,
    String? photoData,
  });

  ResultVoid forgotPassword({
    required String email,
  });

  ResultVoid updateUser({
    required dynamic userData,
    required UpdateUserAction action,
  });

  ResultVoid signOut();
}
