import 'dart:convert';

class CvvService {
  static const secretKey = 'secret';

  static String encrypt(String value) {
    return base64Encode(
      _xor(utf8.encode(value), utf8.encode(secretKey)),
    );
  }

  static String decrypt(String value) {
    return utf8.decode(_xor(base64Decode(value), utf8.encode(secretKey)));
  }

  /// xor encryption & decryption using the secret key
  static List<int> _xor(List<int> bytes, List<int> keys) {
    return bytes.map((e) => e ^ keys[bytes.length % keys.length]).toList();
  }
}
