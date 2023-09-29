import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/auth/domain/entities/local_user.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/sign_in.dart';

import 'auth_repo.mock.dart';

void main() {
  late IAuthRepo repository;
  late SignIn usecase;

  final tUser = LocalUser.empty();
  const tFailure = ServerFailure(
    message: 'Server Failure',
    statusCode: 500,
  );
  const params = SignInParams.empty();

  setUp(() {
    repository = MockAuthRepo();
    usecase = SignIn(repository);
  });

  group('SignIn', () {
    test(
      'should call the [AuthRepo.signIn] '
      'and return [LocalUser] if successfull',
      () async {
        // arrange
        when(
          () => repository.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(tUser));

        // act
        final result = await usecase(params);

        // assert
        expect(result, Right<dynamic, LocalUser>(tUser));

        verify(
          () => repository.signIn(
            email: params.email,
            password: params.password,
          ),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
    test(
      'should call the [AuthRepo.signIn] '
      'and return [ServerFailure] if unsuccessfull',
      () async {
        // arrange
        when(
          () => repository.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(params);

        // assert
        expect(result, const Left<Failure, dynamic>(tFailure));

        verify(
          () => repository.signIn(
            email: params.email,
            password: params.password,
          ),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
  });
}
