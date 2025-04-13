import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/addpasswordmodel.dart';
import 'encryption_service.dart';

class DatabaseService with ChangeNotifier {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  final EncryptionService _encryptionService = EncryptionService();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'passwords.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 2, // Increased version for migration
      onUpgrade: _onUpgrade,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE passwords(id TEXT PRIMARY KEY, title TEXT, url TEXT, username TEXT, password TEXT, notes TEXT, addeddate TEXT, is_encrypted INTEGER DEFAULT 0)',
    );
  }

  // Handle migration from unencrypted to encrypted
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add is_encrypted column
      await db.execute('ALTER TABLE passwords ADD COLUMN is_encrypted INTEGER DEFAULT 0');
      
      // Migrate existing data to encrypted format
      await _migrateToEncryption(db);
    }
  }

  // Migrate existing data to encrypted format
  Future<void> _migrateToEncryption(Database db) async {
    final List<Map<String, dynamic>> rows = await db.query('passwords');
    
    for (var row in rows) {
      // Skip already encrypted data
      if (row['is_encrypted'] == 1) continue;
      
      // Encrypt sensitive fields
      final Map<String, dynamic> encryptedRow = {...row};
      encryptedRow['username'] = _encryptionService.encryptString(row['username'] ?? '');
      encryptedRow['password'] = _encryptionService.encryptString(row['password'] ?? '');
      if (row['notes'] != null) {
        encryptedRow['notes'] = _encryptionService.encryptString(row['notes']);
      }
      encryptedRow['is_encrypted'] = 1;
      
      // Update the row with encrypted data
      await db.update(
        'passwords', 
        encryptedRow,
        where: 'id = ?',
        whereArgs: [row['id']],
      );
    }
  }

  Future<void> addPassword({required AddPasswordModel password}) async {
    final db = await _databaseService.database;

    // Create a copy of the password map and encrypt sensitive fields
    final encryptedData = password.toMap();
    encryptedData['username'] = _encryptionService.encryptString(password.username);
    encryptedData['password'] = _encryptionService.encryptString(password.password);
    if (password.notes != null && password.notes!.isNotEmpty) {
      encryptedData['notes'] = _encryptionService.encryptString(password.notes!);
    }
    encryptedData['is_encrypted'] = 1;

    await db.insert(
      'passwords',
      encryptedData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
    log('inputted data ${password.toMap().toString()}');
  }

  Future<List<AddPasswordModel>> passwords() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('passwords');
    
    return List.generate(maps.length, (index) {
      final data = {...maps[index]};
      
      // Decrypt data if encrypted
      if (data['is_encrypted'] == 1) {
        try {
          if (data['username'] != null) {
            data['username'] = _encryptionService.decryptString(data['username']);
          }
          if (data['password'] != null) {
            data['password'] = _encryptionService.decryptString(data['password']);
          }
          if (data['notes'] != null && data['notes'].isNotEmpty) {
            data['notes'] = _encryptionService.decryptString(data['notes']);
          }
        } catch (e) {
          log('Error decrypting: ${e.toString()}');
        }
      }
      
      notifyListeners();
      return AddPasswordModel.fromMap(data);
    });
  }

  Future<AddPasswordModel> selectedPasword(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('passwords', where: 'id = ?', whereArgs: [id]);
    
    if (maps.isEmpty) {
      throw Exception('Password not found');
    }
    
    final data = {...maps[0]};
    
    // Decrypt data if encrypted
    if (data['is_encrypted'] == 1) {
      try {
        if (data['username'] != null) {
          data['username'] = _encryptionService.decryptString(data['username']);
        }
        if (data['password'] != null) {
          data['password'] = _encryptionService.decryptString(data['password']);
        }
        if (data['notes'] != null && data['notes'].isNotEmpty) {
          data['notes'] = _encryptionService.decryptString(data['notes']);
        }
      } catch (e) {
        log('Error decrypting: ${e.toString()}');
      }
    }
    
    notifyListeners();
    return AddPasswordModel.fromMap(data);
  }

  Future<void> deletePassword(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

  Future<void> updatePassword({required AddPasswordModel password}) async {
    final db = await _databaseService.database;

    // Create a copy of the password map and encrypt sensitive fields
    final encryptedData = password.toMap();
    encryptedData['username'] = _encryptionService.encryptString(password.username);
    encryptedData['password'] = _encryptionService.encryptString(password.password);
    if (password.notes != null && password.notes!.isNotEmpty) {
      encryptedData['notes'] = _encryptionService.encryptString(password.notes!);
    }
    encryptedData['is_encrypted'] = 1;

    await db.update(
      'passwords',
      encryptedData,
      conflictAlgorithm: ConflictAlgorithm.replace,
      where: 'id = ?',
      whereArgs: [password.id],
    );

    log('${password.id} updated');
    notifyListeners();
  }

  Future<void> clearHistory() async {
    final db = await _databaseService.database;

    await db.delete(
      'passwords',
    );
  }
}
