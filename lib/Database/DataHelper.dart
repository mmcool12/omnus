import 'dart:io';
import 'package:omnus/Database/DataModels.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DataHelper {
  static final _databaseName = 'Accounts.db';
  static final _databaseVersion = 1;

  DataHelper._privateConstructor();
  static final DataHelper instance = DataHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
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
    CREATE TABLE accounts (
      number TEXT PRIMARY KEY,
      pkey TEXT,
      akey TEXT NOT NULL,
      itemid TEXT NOT NULL,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      abalance TEXT NOT NULL,
      cbalance TEXT NOT NULL
      )
    '''); 
  }

  addAccount(StoredAccount account) async {
    Database db = await database;
    await db.insert('accounts', account.toMap());
  }

  updateDatabase(String column) async {
    Database db = await database;
    await db.execute('''
    ALTER TABLE accounts
    ADD $column TEXT
    ''');
  }

  deleteAccount(String number) async {
    Database db = await database;
    await db.delete('accounts', where: 'number = ?', whereArgs: [number]);
  }

  Future<StoredAccount> queryAccountByNumber(String number) async {
    Database db = await database;
    List<Map> maps = await db.query('accounts', 
    columns: ['number', 'pkey', 'akey', 'itemid', 'name', 'type', 'abalance', 'cbalance'],
    where: 'number = ?',
    whereArgs: [number]);
    if (maps.length > 0){
      return StoredAccount.fromMap(maps.first);
    }
    return null;
  }

  Future<List<StoredAccount>> queryAccountByType(String type) async {
    Database db = await database;
    List<Map> maps = await db.query('accounts', 
    columns: ['number', 'pkey', 'akey', 'itemid', 'name', 'type', 'abalance', 'cbalance'],
    where: 'type = ?',
    whereArgs: [type]);
    if (maps.length > 0){
      List<StoredAccount> accounts = [];
      for (Map a in maps) accounts.add(StoredAccount.fromMap(a));
      return accounts;
    }
    return null;
  }

  Future<List<StoredAccount>> queryAllAccounts() async {
    Database db =  await database;
    List<Map> maps= await db.query('accounts',
      columns: ['number', 'pkey', 'akey', 'itemid', 'name', 'type', 'abalance', 'cbalance'],
      where: null,
    );
    if (maps.length > 0) {
      List<StoredAccount> accounts = [];
      for (Map a in maps) accounts.add(StoredAccount.fromMap(a));
      return accounts;
    }
    return null;
  }

}