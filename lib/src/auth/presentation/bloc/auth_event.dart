part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.username,
  });

  final String email;
  final String password;
  final String username;
}

class ForgotPasswordEvent extends AuthEvent {
  const ForgotPasswordEvent({
    required this.email,
  });

  final String email;
}

class UpdateUserEvent extends AuthEvent {
  UpdateUserEvent({
    required this.userData,
    required this.action,
  }) : assert(
          userData is String || userData is File,
          '[userData] must be either String or File, '
          'received ${userData.runtimeType}',
        );

  final dynamic userData;
  final UpdateUserAction action;
}

class SignOutEvent extends AuthEvent {}
