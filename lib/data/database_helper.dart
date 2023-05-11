import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "ExemploDB.db";
  static const _databaseVersion = 1;

  static const table = 'aluno';
  static const columnId = '_id';
  static const columnNome = 'nome';
  static const columnSobrenome = 'sobrenome';
  static const columnRa = 'ra';
  static const columnEmail = 'email';
  static const columnCurso = 'curso';
  static const columnSemestre = 'semestre';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnNome TEXT NOT NULL,
            $columnSobrenome TEXT NOT NULL,
            $columnRa INTEGER NOT NULL,
            $columnEmail TEXT NOT NULL,
            $columnCurso TEXT NOT NULL,
            $columnSemestre INT NOT NULL
          )
          ''');
  } 


  // CRUDDO
  // Create
  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;

    return await db?.insert(table, row);
  }

  // Read
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;

    return await db!.query(table);
  }

  Future<int?> queryRowCount() async {
    Database? db = await instance.database;

    return Sqflite.firstIntValue(
      await db!.rawQuery('SELECT COUNT(*) FROM $table')
    );
  }

  // Update
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;

    int id = row[columnId];

    return await db!.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // DELETE
  Future<int> delete(int id) async {
    Database? db = await instance.database;

    return await db!.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id]
    );
  }
}