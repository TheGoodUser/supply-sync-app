import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class AesGcmEncryption {
  static final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );
  static final _aesGcm = AesGcm.with256bits();

  /// Generate a random salt / nonce (for PBKDF2)
  static Uint8List _generateSalt([int length = 16]) {
    final rnd = Random.secure();
    final salt = List<int>.generate(length, (_) => rnd.nextInt(256));
    return Uint8List.fromList(salt);
  }

  /// Derive a 256-bit SecretKey from a password + salt
  static Future<SecretKey> _deriveKey(
      String password, Uint8List salt) async {
    return await _pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: salt.toList(),
    );
  }

  /// Encrypt plaintext (UTF-8) with a password.
  ///
  /// Returns a Map containing:
  /// - salt: base64 salt used for key derivation
  /// - iv: base64 nonce used for AES-GCM
  /// - cipherText: base64 encrypted data
  /// - tag: base64 authentication tag
  static Future<Map<String, String>> encrypt(
      String plainText, String password) async {
    final salt = _generateSalt();
    final secretKey = await _deriveKey(password, salt);

    final iv = _aesGcm.newNonce(); // GCM nonce
    final secretBox = await _aesGcm.encrypt(
      utf8.encode(plainText),
      secretKey: secretKey,
      nonce: iv,
    );

    return {
      'salt': base64.encode(salt),
      'iv': base64.encode(iv),
      'cipherText': base64.encode(secretBox.cipherText),
      'tag': base64.encode(secretBox.mac.bytes),
    };
  }

  /// Decrypt an encrypted payload using the same password
  static Future<String> decrypt(
      Map<String, dynamic> encrypted, String password) async {
    final salt = base64.decode(encrypted['salt']!);
    final iv = base64.decode(encrypted['iv']!);
    final cipherText = base64.decode(encrypted['cipherText']!);
    final tag = base64.decode(encrypted['tag']!);

    final secretKey = await _deriveKey(password, salt);
    final secretBox = SecretBox(
      cipherText,
      nonce: iv,
      mac: Mac(tag),
    );

    final clearBytes = await _aesGcm.decrypt(
      secretBox,
      secretKey: secretKey,
    );
    return utf8.decode(clearBytes);
  }
}
