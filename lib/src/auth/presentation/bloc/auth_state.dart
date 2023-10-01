part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class SignedIn extends AuthState {
  const SignedIn(this.user);
  //only in datasource we use [LocalUserModel] type
  final LocalUser user;

  @override
  List<LocalUser> get props => [user];
}

class SignedUp extends AuthState {
  const SignedUp();
}

class ForgotPasswordSent extends AuthState {
  const ForgotPasswordSent();
}

class UserUpdated extends AuthState {
  const UserUpdated();
}

class UserSignedOut extends AuthState {
  const UserSignedOut();
}

class AuthError extends AuthState {
  const AuthError(
    this.message,
  );
  final String message;

  @override
  List<String> get props => [message];
}
