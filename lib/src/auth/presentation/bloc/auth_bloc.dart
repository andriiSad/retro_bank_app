import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:retro_bank_app/core/enums/update_user_action.dart';
import 'package:retro_bank_app/src/auth/domain/entities/local_user.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/sign_in.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/sign_out.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/sign_up.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required UpdateUser updateUser,
    required SignOut signOut,
  })  : _signIn = signIn,
        _signUp = signUp,
        _forgotPassword = forgotPassword,
        _updateUser = updateUser,
        _signOut = signOut,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
    on<SignOutEvent>(_signOutHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;
  final SignOut _signOut;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        username: event.username,
        photoUrl: event.photoUrl,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(
      ForgotPasswordParams(
        email: event.email,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        userData: event.userData,
        action: event.action,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const UserUpdated()),
    );
  }

  Future<void> _signOutHandler(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const UserSignedOut()),
    );
  }
}
