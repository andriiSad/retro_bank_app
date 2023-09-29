import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:retro_bank_app/src/on_boarding/domain/usecases/cache_first_timer.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late IOnBoardingRepo repo;
  late CacheFirstTimer usecase;

  setUp(
    () => {
      repo = MockOnBoardingRepo(),
      usecase = CacheFirstTimer(repo),
    },
  );

  test(
    'should call the [OnBoardingRepo.cacheFirstTimer] '
    'and return positive response',
    () async {
      // arrange
      when(
        () => repo.cacheFirstTimer(),
      ).thenAnswer(
        (_) async => const Right(
          null,
        ),
      );
      // act
      final result = await usecase();
      // assert

      expect(result, const Right<dynamic, void>(null));

      verify(() => repo.cacheFirstTimer()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );

  test(
    'should call the [OnBoardingRepo.cacheFirstTimer] '
    'and return negative response',
    () async {
      const tFailure = CacheFailure(
        message: 'Insufficient permissions',
        statusCode: 4032,
      );

      // arrange
      when(
        () => repo.cacheFirstTimer(),
      ).thenAnswer(
        (_) async => const Left(
          tFailure,
        ),
      );

      // act
      final result = await usecase();

      // assert
      expect(result, const Left<Failure, dynamic>(tFailure));

      verify(() => repo.cacheFirstTimer()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
