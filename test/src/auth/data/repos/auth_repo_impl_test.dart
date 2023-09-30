import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:retro_bank_app/src/auth/data/models/local_user_model.dart';
import 'package:retro_bank_app/src/auth/data/repos/auth_repo_impl.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/sign_in.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/sign_up.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/update_user.dart';

import 'auth_remote_data_source.mock.dart';

void main() {
  late IAuthRemoteDataSource remoteDataSource;
  late AuthRepoImpl repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImpl(remoteDataSource);
  });

  group('signIn', () {
    const params = SignInParams.empty();
    final tUserModel = LocalUserModel.empty();
    const tException = ServerException(
      message: 'Unknown error occurred',
      statusCode: '500',
    );
    test(
      'should call the [RemoteDataSource.signIn] and return '
      '[LocalUserModel], when the call to remote source is successful',
      () async {
        //arrange
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tUserModel);

        //act
        final result = await repoImpl.signIn(
          email: params.email,
          password: params.password,
        );

        //assert
        expect(result, Right<dynamic, LocalUserModel>(tUserModel));

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.signIn(
            email: params.email,
            password: params.password,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [APIFailure] '
      'when the call to remote source is unsuccessful',
      () async {
        //arrange
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tException);

        //act
        final result = await repoImpl.signIn(
          email: params.email,
          password: params.password,
        );

        //assert
        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure.fromException(
              tException,
            ),
          ),
        );

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.signIn(
            email: params.email,
            password: params.password,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
  group('signUp', () {
    const params = SignUpParams.empty();
    const tException = ServerException(
      message: 'Unknown error occurred',
      statusCode: '500',
    );
    test(
      'should call the [RemoteDataSource.signUp] and complete '
      'successfully, when the call to remote source is successful',
      () async {
        //arrange
        when(
          () => remoteDataSource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
          ),
        ).thenAnswer((_) async => {});

        //act
        final result = await repoImpl.signUp(
          email: params.email,
          password: params.password,
          fullName: params.fullName,
        );

        //assert
        expect(result, const Right<dynamic, void>(null));

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.signUp(
            email: params.email,
            password: params.password,
            fullName: params.fullName,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [APIFailure] '
      'when the call to remote source is unsuccessful',
      () async {
        //arrange
        when(
          () => remoteDataSource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
          ),
        ).thenThrow(tException);

        //act
        final result = await repoImpl.signUp(
          email: params.email,
          password: params.password,
          fullName: params.fullName,
        );

        //assert
        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure.fromException(
              tException,
            ),
          ),
        );

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.signUp(
            email: params.email,
            password: params.password,
            fullName: params.fullName,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
  group('forgotPassword', () {
    const params = ForgotPasswordParams.empty();
    const tException = ServerException(
      message: 'Unknown error occurred',
      statusCode: '500',
    );
    test(
      'should call the [RemoteDataSource.forgotPassword] and complete '
      'successfully, when the call to remote source is successful',
      () async {
        //arrange
        when(
          () => remoteDataSource.forgotPassword(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => {});

        //act
        final result = await repoImpl.forgotPassword(
          email: params.email,
        );

        //assert
        expect(result, const Right<dynamic, void>(null));

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.forgotPassword(
            email: params.email,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [APIFailure] '
      'when the call to remote source is unsuccessful',
      () async {
        //arrange
        when(
          () => remoteDataSource.forgotPassword(
            email: any(named: 'email'),
          ),
        ).thenThrow(tException);

        //act
        final result = await repoImpl.forgotPassword(
          email: params.email,
        );

        //assert
        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure.fromException(
              tException,
            ),
          ),
        );

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.forgotPassword(
            email: params.email,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
  group('updateUser', () {
    const params = UpdateUserParams.empty();
    const tException = ServerException(
      message: 'Unknown error occurred',
      statusCode: '500',
    );

    setUp(() {
      registerFallbackValue(params.action);
    });

    test(
      'should call the [RemoteDataSource.updateUser] and complete '
      'successfully, when the call to remote source is successful',
      () async {
        //arrange
        when(
          () => remoteDataSource.updateUser(
            userData: any<dynamic>(named: 'userData'),
            action: any(named: 'action'),
          ),
        ).thenAnswer((_) async => {});

        //act
        final result = await repoImpl.updateUser(
          userData: params.userData,
          action: params.action,
        );

        //assert
        expect(result, const Right<dynamic, void>(null));

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.updateUser(
            userData: params.userData,
            action: params.action,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [APIFailure] '
      'when the call to remote source is unsuccessful',
      () async {
        //arrange
        when(
          () => remoteDataSource.updateUser(
            userData: any<dynamic>(named: 'userData'),
            action: any(named: 'action'),
          ),
        ).thenThrow(tException);

        //act
        final result = await repoImpl.updateUser(
          userData: params.userData,
          action: params.action,
        );

        //assert
        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure.fromException(
              tException,
            ),
          ),
        );

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.updateUser(
            userData: params.userData,
            action: params.action,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('signOut', () {
    const tException = ServerException(
      message: 'Unknown error occurred',
      statusCode: '500',
    );
    test(
      'should call the [RemoteDataSource.forgotPassword] and complete '
      'successfully, when the call to remote source is successful',
      () async {
        //arrange
        when(() => remoteDataSource.signOut()).thenAnswer((_) async => {});

        //act
        final result = await repoImpl.signOut();

        //assert
        expect(result, const Right<dynamic, void>(null));

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.signOut(),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
    test(
      'should return a [APIFailure] '
      'when the call to remote source is unsuccessful',
      () async {
        //arrange
        when(
          () => remoteDataSource.signOut(),
        ).thenThrow(tException);

        //act
        final result = await repoImpl.signOut();

        //assert
        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure.fromException(
              tException,
            ),
          ),
        );

        //check that remote source's signIn is get called
        verify(
          () => remoteDataSource.signOut(),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
