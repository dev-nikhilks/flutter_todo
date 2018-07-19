import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableTodo = 'todoTable';
  final String columnId = 'id';
  final String columnDate = 'date';
  final String columnTask = 'task';
  final String columnColor = 'color';
  final String columnCategory = 'category';

  DatabaseHelper.internal();

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableTodo($columnId INTEGER PRIMARY KEY, $columnDate TEXT, $columnTask TEXT, $columnColor INTEGER, $columnCategory TEXT )');
  }

  Future<int> saveTask(TodoTable todo) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableTodo, todo.toMap());
    return result;
  }

  Future<List> getAllTasks() async {
    var dbClient = await db;
    var result = await dbClient.query(tableTodo, columns: [columnId, columnDate, columnTask,columnColor,columnCategory]);
    return result.toList();
  }

  Future<List<TodoTable>> getTasks(String date) async {
    var dbClient = await db;
//    List<Map> result = await dbClient.query(tableNote,
//        columns: [columnId, columnDate, columnTask,columnColor,columnCategory],
//        where: '$columnId = ?',
//        whereArgs: [id]);
    var result = await dbClient.rawQuery('SELECT * FROM $tableTodo WHERE $columnDate = "$date"');

    if (result.length > 0) {
      List<TodoTable> table = [];
      for(int i=0;i<result.length;i++) {
        table.add(TodoTable.fromMap(result[0]));
      }
      return table;

    }
    return null;
  }

  Future<int> getCount(String date) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableTodo WHERE $columnDate = $date' ));
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }


}

class TodoTable {
  int _id;
  String _date;
  String _todoTask;
  String _category;
  String _time;

  int _color;
  int _isDone;

  TodoTable(this._id, this._date, this._todoTask, this._category, this._time,
      this._color, this._isDone);


  int get color => _color;

  String get todoTask => _todoTask;

  String get date => _date;

  int get id => _id;

  String get category => _category;

  int get isDone => _isDone;

  String get time => _time;

  TodoTable.map(dynamic obj){
    this._id = obj['id'];
    this._date = obj['date'];
    this._todoTask = obj['task'];
    this._color = obj['color'];
    this._category = obj['category'];
    this._time = obj['time'];
    this._isDone = obj['isDone'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['date'] = date;
    map['task'] = todoTask;
    map['color'] = color;
    map['category'] = category;
    map['time'] = _time;
    map['isDone'] = _isDone;
    return map;
  }

  TodoTable.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._date = map['date'];
    this._todoTask = map['task'];
    this._color = map['color'];
    this._category = map['category'];
    this._time = map['time'];
    this._isDone = map['isDone'];
  }

}