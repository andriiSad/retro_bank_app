import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/errors/failures.dart';
import 'package:retro_bank_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:retro_bank_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:retro_bank_app/src/on_boarding/domain/repos/on_boarding_repo.dart';

import 'on_boarding_local_data_source.mock.dart';

void main() {
  late IOnBoardingLocalDataSource localDataSource;
  late IOnBoardingRepo repo;

  const tException = CacheException(
    message: 'Insufficient storage ',
  );

  setUp(
    () => {
      localDataSource = MockOnBoardingLocalDataSource(),
      repo = OnBoardingRepoImpl(localDataSource),
    },
  );

//not necessary test, but good practice
  test(
    'should be a subclass  of [OnBoardingRepo]',
    () {
      expect(repo, isA<IOnBoardingRepo>());
    },
  );

  group('cacheFirstTimer', () {
    test(
      'should call the [RemoteDataSource.createUser] and complete '
      'successfully, when the call to local source is successful',
      () async {
        //arrange
        when(() => localDataSource.cacheFirstTimer())
            .thenAnswer((_) async => Future.value);

        //act
        final result = await repo.cacheFirstTimer();

        //assert
        expect(result, const Right<dynamic, void>(null));

        verify(() => localDataSource.cacheFirstTimer()).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );
    test(
      'should return a [CacheFailure] '
      'when the call to local source is unsuccessful',
      () async {
        //arrange
        when(() => localDataSource.cacheFirstTimer()).thenThrow(tException);

        //act
        final result = await repo.cacheFirstTimer();

        //assert
        expect(
          result,
          Left<CacheFailure, dynamic>(CacheFailure.fromException(tException)),
        );

        verify(() => localDataSource.cacheFirstTimer()).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );
  });
  group('checkIfUserIsFirstTimer', () {
    test(
      'should call the [RemoteDataSource.checkIfUserIsFirstTimer] and complete '
      'successfully, when the call to local source is successful',
      () async {
        //arrange
        when(() => localDataSource.checkIfUserIsFirstTimer())
            .thenAnswer((_) async => Future.value(true));
        //.thenAnswer((_) async => Future.value()); is also OK for void.

        //act
        final result = await repo.checkIfUserIsFirstTimer();

        //assert
        expect(result, const Right<dynamic, bool>(true));

        verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );
    test(
      'should call the [RemoteDataSource.checkIfUserIsFirstTimer] and complete '
      'successfully, when the call to local source is successful',
      () async {
        //arrange
        when(() => localDataSource.checkIfUserIsFirstTimer())
            .thenAnswer((_) async => Future.value(false));
        //.thenAnswer((_) async => Future.value()); is also OK for void.

        //act
        final result = await repo.checkIfUserIsFirstTimer();

        //assert
        expect(result, const Right<dynamic, bool>(false));

        verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );
    test(
      'should return a [CacheFailure] '
      'when the call to local source is unsuccessful',
      () async {
        //arrange
        when(() => localDataSource.checkIfUserIsFirstTimer())
            .thenThrow(tException);

        //act
        final result = await repo.checkIfUserIsFirstTimer();

        //assert
        expect(
          result,
          Left<Failure, dynamic>(CacheFailure.fromException(tException)),
        );

        verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);

        verifyNoMoreInteractions(localDataSource);
      },
    );
  });
}
