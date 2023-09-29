import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/utils/constants.dart';
import 'package:retro_bank_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences.mock.dart';

void main() {
  late SharedPreferences prefs;
  late IOnBoardingLocalDataSource localDataSource;

  const tErrorMessage = 'Setting a bool failed';

  setUp(
    () => {
      prefs = MockSharedPreferences(),
      localDataSource = OnBoardingLocalDataSourceImpl(prefs),
    },
  );

  group('cacheFirstTimer', () {
    test(
      'should call the [OnBoardingLocalDataSourceImpl.cacheFirstTimer] '
      'and return [void] if the [prefs.setBool] is successful',
      () async {
        // arrange
        when(() => prefs.setBool(any(), any())).thenAnswer(
          (_) async => true,
        );

        // act
        await localDataSource.cacheFirstTimer();

        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );

    //When we are testing for errors in the datasources,
    // we do not save the RESULT, we save CALL

    test(
      'should call the [OnBoardingLocalDataSourceImpl.cacheFirstTimer] '
      'and throw [CacheException] if the [prefs.setBool] is unsuccessful',
      () async {
        // arrange
        when(() => prefs.setBool(any(), any())).thenThrow(
          Exception(tErrorMessage),
        );

        // act
        final methodCall = localDataSource.cacheFirstTimer;

        // assert
        expect(
          methodCall,
          throwsA(isA<CacheException>()),
        );

        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );
  });
  group('checkIfUserIsFirstTimer', () {
    test(
      'should call the [OnBoardingLocalDataSourceImpl.checkIfUserIsFirstTimer] '
      'and return [Future<false>] if data exists',
      () async {
        // arrange
        when(() => prefs.getBool(any())).thenReturn(false);

        // act
        final result = await localDataSource.checkIfUserIsFirstTimer();

        // assert
        expect(result, false);

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );
    test(
      'should call the [OnBoardingLocalDataSourceImpl.checkIfUserIsFirstTimer] '
      'and return [Future<true>] if data does not exist',
      () async {
        // arrange
        when(() => prefs.getBool(any())).thenReturn(true);

        // act
        final result = await localDataSource.checkIfUserIsFirstTimer();

        // assert
        expect(result, true);

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );
    test(
      'should call the [OnBoardingLocalDataSourceImpl.checkIfUserIsFirstTimer] '
      'and return [Future<true>] if the [prefs.getBool] is null',
      () async {
        // arrange
        when(() => prefs.getBool(any())).thenReturn(null);

        // act
        final result = await localDataSource.checkIfUserIsFirstTimer();

        // assert
        expect(result, true);

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );

    test(
      'should call the [OnBoardingLocalDataSourceImpl.checkIfUserIsFirstTimer] '
      'and throw [CacheException] if the [prefs.getBool] throws [Exception]',
      () async {
        // arrange
        when(() => prefs.getBool(any())).thenThrow(
          Exception(tErrorMessage),
        );

        // act
        final methodCall = localDataSource.checkIfUserIsFirstTimer();

        // assert
        expect(
          methodCall,
          throwsA(isA<CacheException>()),
        );

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );
  });
}
