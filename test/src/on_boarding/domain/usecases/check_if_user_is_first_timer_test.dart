import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:retro_bank_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late IOnBoardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(
    () => {
      repo = MockOnBoardingRepo(),
      usecase = CheckIfUserIsFirstTimer(repo),
    },
  );

  test(
    'should call the [OnBoardingRepo.checkIfUserIsFirstTimer]',
    () async {
      // arrange
      when(() => repo.checkIfUserIsFirstTimer()).thenAnswer(
        (_) async => const Right(true),
      );

      // act
      final result = await usecase();

      // assert
      expect(result, const Right<dynamic, bool>(true));

      verify(() => repo.checkIfUserIsFirstTimer()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
