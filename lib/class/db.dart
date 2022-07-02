import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final _databaseName = "pesquisaSatisfacao.db";
  static final _databaseVersion = 1;
  static final table = 'respostas';
  static final columnIdResposta = '_id';
  static final columnResposta1 = 'resposta1';
  static final columnResposta2 = 'resposta2';
  static final columnResposta3 = 'resposta3';
  static final columnResposta4 = 'resposta4';
  static final columnResposta5 = 'resposta5';
  static final columnResposta6 = 'resposta6';
  static final columnResposta7 = 'resposta7';
  static final columnResposta8 = 'resposta8';
  static final columnResposta9 = 'resposta9';
  static final columnResposta_10 = 'resposta_10';
  static final columnResposta_11 = 'resposta_11';
  static final columnResposta_12 = 'resposta_12';
  static final columnResposta_13 = 'resposta_13';
  static final columnResposta_14 = 'resposta_14';
  static final columnResposta_15 = 'resposta_15';
  static final columnResposta_16 = 'resposta_16';
  static final columnResposta_17 = 'resposta_17';
  static final columnResposta_18 = 'resposta_18';
  static final columnResposta_19 = 'resposta_19';
  static final columnResposta_20 = 'resposta_20';
  static final columnResposta_21 = 'resposta_21';
  static final columnResposta_22 = 'resposta_22';
  static final columnResposta_23 = 'resposta_23';
  static final columnResposta_24 = 'resposta_24';
  static final columnResposta_25 = 'resposta_25';
  static final columnidPesquisa = 'idPesquisa';
  static final columnEnviou = 'enviou';
  static final columnUsuario = 'usuario';
  static final columnTempo = 'tempo';
  static final columnnomePesquisa = 'nomePesquisa';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnIdResposta INTEGER PRIMARY KEY,
            $columnResposta1 TEXT,
            $columnResposta2 TEXT,
            $columnResposta3 TEXT,
            $columnResposta4 TEXT,
            $columnResposta5 TEXT,
            $columnResposta6 TEXT,
            $columnResposta7 TEXT,
            $columnResposta8 TEXT,
            $columnResposta9 TEXT,
            $columnResposta_10 TEXT,
            $columnResposta_11 TEXT,
            $columnResposta_12 TEXT,
            $columnResposta_13 TEXT,
            $columnResposta_14 TEXT,
            $columnResposta_15 TEXT,
            $columnResposta_16 TEXT,
            $columnResposta_17 TEXT,
            $columnResposta_18 TEXT,
            $columnResposta_19 TEXT,
            $columnResposta_20 TEXT,
            $columnResposta_21 TEXT,
            $columnResposta_22 TEXT,
            $columnResposta_23 TEXT,
            $columnResposta_24 TEXT,
            $columnResposta_25 TEXT,
            $columnEnviou TEXT,
            $columnUsuario TEXT,
            $columnTempo TEXT,
            $columnnomePesquisa TEXT
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map>> result() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT $columnResposta1, $columnResposta2, $columnResposta3, $columnResposta4,'
            '$columnResposta5, $columnResposta6, $columnResposta7, $columnResposta8, $columnResposta9,'
            '$columnResposta_10, $columnResposta_11, $columnResposta_12, $columnResposta_13,'
            '$columnResposta_14, $columnResposta_15, $columnResposta_16, $columnResposta_17, '
            '$columnResposta_18, $columnResposta_19, $columnResposta_20, $columnResposta_21, '
            '$columnResposta_22, $columnResposta_23, $columnResposta_24, $columnResposta_25, '
            '$columnUsuario, $columnTempo, $columnnomePesquisa '
            'FROM $table WHERE $columnEnviou=?', ['nao']);
  }

  Future<List<Map>> idPesquisa() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT $columnIdResposta FROM $table WHERE $columnEnviou=?', ['nao']);
  }

  Future<int> queryRowCount(String idUsuario) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE $columnEnviou="nao" AND $columnUsuario="$idUsuario"'));
  }

  Future<int> update(String idUsuario) async {
    Database db = await instance.database;
    return await db.update(table, {'$columnEnviou': 'sim'}, where: '$columnEnviou ="nao" AND $columnUsuario="$idUsuario"');
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnIdResposta = ?', whereArgs: [id]);
  }
}