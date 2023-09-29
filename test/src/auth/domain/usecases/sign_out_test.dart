import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/auth/domain/repos/auth_repo.dart';
import 'package:retro_bank_app/src/auth/domain/usecases/sign_out.dart';

import 'auth_repo.mock.dart';

void main() {
  late IAuthRepo repository;
  late SignOut usecase;

  const tFailure = ServerFailure(
    message: 'Server Failure',
    statusCode: 500,
  );

  setUp(() {
    repository = MockAuthRepo();
    usecase = SignOut(repository);
  });

  group('SignOut', () {
    test(
      'should call the [AuthRepo.signOut] '
      'and return [void] if successfull',
      () async {
        // arrange
        when(
          () => repository.signOut(),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await usecase();

        // assert
        expect(result, const Right<dynamic, void>(null));

        verify(
          () => repository.signOut(),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
    test(
      'should call the [AuthRepo.signOut] '
      'and return [ServerFailure] if unsuccessfull',
      () async {
        // arrange
        when(
          () => repository.signOut(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase();

        // assert
        expect(result, const Left<Failure, dynamic>(tFailure));

        verify(
          () => repository.signOut(),
        ).called(1);

        verifyNoMoreInteractions(repository);
      },
    );
  });
}
