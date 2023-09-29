import 'package:flutter_test/flutter_test.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';
import 'package:retro_bank_app/core/errors/failures.dart';

void main() {
  group('CacheFailure', () {
    const tFailure = CacheFailure(
      message: 'Test Message',
      statusCode: 404,
    );
    const tException = CacheException(
      message: 'Exception Message',
      statusCode: 403,
    );

    test('should extend Failure', () {
      expect(tFailure, isA<Failure>());
    });

    test('should have proper props', () {
      expect(tFailure.props, [tFailure.message, tFailure.statusCode]);
    });

    test('should throw an error with invalid statusCode type', () {
      // Pass an invalid type (double) for statusCode
      expect(
        () => CacheFailure(message: 'Test Message', statusCode: 42.0),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.toString(),
            'toString',
            contains('statusCode must be a String or int, not: 42.0'),
          ),
        ),
      );
    });

    test('should create CacheFailure from CacheException', () {
      final failure = CacheFailure.fromException(tException);

      expect(failure.message, tException.message);
      expect(failure.statusCode, tException.statusCode);
    });
  });

  group('ServerFailure', () {
    const tFailure = ServerFailure(message: 'Test Message', statusCode: 500);
    const tException = ServerException(
      message: 'Exception Message',
      statusCode: '404',
    );

    test('should extend Failure', () {
      expect(tFailure, isA<Failure>());
    });

    test('should have proper props', () {
      expect(tFailure.props, [tFailure.message, tFailure.statusCode]);
    });

    test('should throw an error with invalid statusCode type', () {
      // Pass an invalid type (bool) for statusCode
      expect(
        () => ServerFailure(message: 'Test Message', statusCode: true),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.toString(),
            'toString',
            contains('statusCode must be a String or int, not: true'),
          ),
        ),
      );
    });

    test('should create ServerFailure from ServerException', () {
      final failure = ServerFailure.fromException(tException);

      expect(failure.message, tException.message);
      expect(failure.statusCode, tException.statusCode);
    });
  });
}
