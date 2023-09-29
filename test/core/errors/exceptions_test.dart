import 'package:flutter_test/flutter_test.dart';
import 'package:retro_bank_app/core/errors/exceptions.dart';

void main() {
  group('ServerException', () {
    const tException = ServerException(
      message: 'Test Message',
      statusCode: '500',
    );

    test('should extend Exception', () {
      expect(tException, isA<Exception>());
    });

    test('should have proper props', () {
      expect(tException.props, [tException.message, tException.statusCode]);
    });
  });

  group('CacheException', () {
    const tException = CacheException(message: 'Test Message', statusCode: 404);
    test('should extend Exception', () {
      expect(tException, isA<Exception>());
    });

    test('should have proper props', () {
      expect(tException.props, [tException.message, tException.statusCode]);
    });
  });
}
