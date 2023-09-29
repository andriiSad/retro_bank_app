import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/update_user.dart';

import 'auth_repo.mock.dart';

void main() {
  late IAuthRepo repository;
  late UpdateUser usecase;

  const params = UpdateUserParams.empty();
  const tFailure = ServerFailure(
    message: 'Server Failure',
    statusCode: 500,
  );

  setUp(() {
    repository = MockAuthRepo();
    usecase = UpdateUser(repository);

    registerFallbackValue(params.action);
  });

  group('UpdateUser', () {
    test(
      'should call the [AuthRepo.updateUser] '
      'and return [void] if successfull',
      () async {
        // arrange
        when(
          () => repository.updateUser(
            userData: any<dynamic>(named: 'userData'),
            action: any(named: 'action'),
          ),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await usecase(params);

        // assert
        expect(result, const Right<dynamic, void>(null));

        verify(
          () => repository.updateUser(
            userData: params.userData,
            action: params.action,
          ),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );

    test(
      'should call the [AuthRepo.updateUser] '
      'and return [ServerFailure] if unsuccessfull',
      () async {
        // arrange
        when(
          () => repository.updateUser(
            userData: any<dynamic>(named: 'userData'),
            action: any(named: 'action'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(params);

        // assert
        expect(result, const Left<Failure, dynamic>(tFailure));

        verify(
          () => repository.updateUser(
            userData: params.userData,
            action: params.action,
          ),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
  });
}
