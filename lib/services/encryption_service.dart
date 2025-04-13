import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  late encrypt.Encrypter _encrypter;
  late encrypt.IV _iv;
  final _secureStorage = const FlutterSecureStorage();
  static const _keyStorageKey = 'encryption_key';
  static const _ivStorageKey = 'encryption_iv';

  // Initialize encryption key and IV
  Future<void> initialize() async {
    // Generate or retrieve the encryption key
    String? storedKey = await _secureStorage.read(key: _keyStorageKey);
    String? storedIV = await _secureStorage.read(key: _ivStorageKey);

    if (storedKey == null || storedIV == null) {
      // Generate new key and IV if not exists
      final key = encrypt.Key.fromSecureRandom(32);
      final iv = encrypt.IV.fromSecureRandom(16);

      // Store them securely
      await _secureStorage.write(key: _keyStorageKey, value: base64.encode(key.bytes));
      await _secureStorage.write(key: _ivStorageKey, value: base64.encode(iv.bytes));

      _encrypter = encrypt.Encrypter(encrypt.AES(key));
      _iv = iv;
    } else {
      // Use existing key and IV
      final key = encrypt.Key(base64.decode(storedKey));
      _iv = encrypt.IV(base64.decode(storedIV));
      _encrypter = encrypt.Encrypter(encrypt.AES(key));
    }
  }

  // Encrypt a string
  String encryptString(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  // Decrypt a string
  String decryptString(String encryptedText) {
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  // Hash master password
  String hashMasterPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Verify master password
  bool verifyMasterPassword(String inputPassword, String hashedPassword) {
    final hashedInput = hashMasterPassword(inputPassword);
    return hashedInput == hashedPassword;
  }
} 