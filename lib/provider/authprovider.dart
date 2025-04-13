import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/encryption_service.dart';

class AuthProvider with ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();
  final EncryptionService _encryptionService = EncryptionService();
  static const _masterPasswordKey = 'master_password_hash';
  static const _legacyPasswordKey = 'password'; // For migration

  AuthProvider() {
    _migrateMasterPassword();
  }
  
  bool _isObsecured = true;
  bool get isObsecured => _isObsecured;
  set isObsecured(bool value) {
    _isObsecured = value;
    notifyListeners();
  }

  late String _masterpassword;
  String get masterpassword => _masterpassword;
  set masterpassword(String value) {
    _masterpassword = value;
    notifyListeners();
  }

  // Migrate from SharedPreferences to secure storage with hashing
  Future<void> _migrateMasterPassword() async {
    // Check if we already have a securely stored master password
    final securePassword = await _secureStorage.read(key: _masterPasswordKey);
    if (securePassword != null) {
      masterpassword = securePassword;
      return;
    }

    // If not, check if there's a legacy password to migrate
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final legacyPassword = prefs.getString(_legacyPasswordKey);
    if (legacyPassword != null && legacyPassword.isNotEmpty) {
      // Hash and store securely
      final hashedPassword = _encryptionService.hashMasterPassword(legacyPassword);
      await _secureStorage.write(key: _masterPasswordKey, value: hashedPassword);
      masterpassword = hashedPassword;
      
      // Delete the old plaintext password
      await prefs.remove(_legacyPasswordKey);
    } else {
      masterpassword = '';
    }
  }

  // Save password securely with hashing
  void savePassword({required String password}) async {
    // Hash the master password before storing
    final hashedPassword = _encryptionService.hashMasterPassword(password);
    await _secureStorage.write(key: _masterPasswordKey, value: hashedPassword);
    masterpassword = hashedPassword;
  }

  Future<void> getMasterPassword() async {
    final securePassword = await _secureStorage.read(key: _masterPasswordKey);
    if (securePassword != null) {
      masterpassword = securePassword;
    } else {
      // Check legacy storage as fallback
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final legacyPassword = prefs.getString(_legacyPasswordKey);
      if (legacyPassword != null && legacyPassword.isNotEmpty) {
        // Handle legacy password migration
        savePassword(password: legacyPassword);
        await prefs.remove(_legacyPasswordKey);
      } else {
        masterpassword = '';
      }
    }
  }

  // Verify password against stored hash
  Future<bool> verifyMasterPassword(String inputPassword) async {
    final storedHash = await _secureStorage.read(key: _masterPasswordKey);
    if (storedHash == null) return false;
    return _encryptionService.verifyMasterPassword(inputPassword, storedHash);
  }
}
