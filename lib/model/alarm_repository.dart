import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoonlarm/model/alarm.dart';

class AlarmRepository {
  static final _databaseName = "nono_database.db";
  static final _databaseVersion = 1;

  static final table = 'alarms';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnSeconds = 'alarm_seconds';
  static final columnCreatedTimeStamp = 'created_timestamp';

  // make this a singleton class
  AlarmRepository._privateConstructor();
  static final AlarmRepository instance = AlarmRepository._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnSeconds INTEGER NOT NULL,
            $columnCreatedTimeStamp 
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Alarm alarm) async {
    if (alarm.title == null || alarm.alarmSeconds == null) {
      throw new Exception("invalid request. update entity must have id");
    }
    var row = new Map<String, dynamic>();
    row[columnTitle] = alarm.title;
    row[columnSeconds] = alarm.alarmSeconds;
    row[columnCreatedTimeStamp] = new DateTime.now().millisecondsSinceEpoch ~/ 1000;
    Database db = await instance.database;
    return db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Alarm>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> list = await db.query(table);
    return list.map((row) {
      return Alarm(id: row[columnId], title: row[columnTitle], alarmSeconds: row[columnSeconds], createdTimestamp: row[columnCreatedTimeStamp]);
    }).toList();
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(1) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Alarm alarm) async {
    if (alarm.id == null || alarm.title == null || alarm.alarmSeconds == null || alarm.createdTimestamp == null) {
      throw new Exception("invalid request. update entity must have id");
    }
    Database db = await instance.database;
    var row = new Map();
    row[columnId] = alarm.id;
    row[columnTitle] = alarm.title;
    row[columnSeconds] = alarm.alarmSeconds;
    row[columnCreatedTimeStamp] = alarm.createdTimestamp;
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [alarm.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}