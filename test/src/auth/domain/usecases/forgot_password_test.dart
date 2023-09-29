import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/forgot_password.dart';

import 'auth_repo.mock.dart';

void main() {
  late IAuthRepo repository;
  late ForgotPassword usecase;

  const params = ForgotPasswordParams.empty();
  const tFailure = ServerFailure(
    message: 'Server Failure',
    statusCode: 500,
  );

  setUp(() {
    repository = MockAuthRepo();
    usecase = ForgotPassword(repository);
  });

  group('ForgotPassword', () {
    test(
      'should call the [AuthRepo.forgotPassword] '
      'and return [void] if successfull',
      () async {
        // arrange
        when(
          () => repository.forgotPassword(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await usecase(params);

        // assert
        expect(result, const Right<dynamic, void>(null));

        verify(
          () => repository.forgotPassword(
            email: params.email,
          ),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
    test(
      'should call the [AuthRepo.forgotPassword] '
      'and return [ServerFailure] if unsuccessfull',
      () async {
        // arrange
        when(
          () => repository.forgotPassword(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(params);

        // assert
        expect(result, const Left<Failure, dynamic>(tFailure));

        verify(
          () => repository.forgotPassword(
            email: params.email,
          ),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
  });
}
