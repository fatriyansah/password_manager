import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/password_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB('passwords.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE passwords(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        account TEXT NOT NULL,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Tabel user
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // CREATE
  Future<int> insertPassword(PasswordModel model) async {
    final db = await instance.database;
    return await db.insert('passwords', model.toMap());
  }

  // READ
  Future<List<PasswordModel>> getPasswords() async {
    final db = await instance.database;
    final result = await db.query('passwords');
    return result.map((e) => PasswordModel.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updatePassword(PasswordModel model) async {
    final db = await instance.database;
    return await db.update(
      'passwords',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // DELETE
  Future<int> deletePassword(int id) async {
    final db = await instance.database;
    return await db.delete('passwords', where: 'id = ?', whereArgs: [id]);
  }

  // REGISTER
  Future<int> registerUser(String username, String password) async {
    final db = await instance.database;

    return await db.insert(
      'users',
      {
        'username': username,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // LOGIN
  Future<bool> loginUser(String username, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }
}

