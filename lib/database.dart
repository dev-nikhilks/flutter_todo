import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableDate = "todo";
final String tableDateId = "date_id";
final String tableDateMilli = "date_mill";

class Date {
  int id;
  int dateMilli;

  Map toMap() {
    Map map = {tableDateMilli: dateMilli};
    if (id != null) {
      map[tableDateId] = id;
    }
    return map;
  }

  Date();

  Date.fromMap(Map map) {
    id = map[tableDateId];
    dateMilli = map[tableDateMilli];
  }
}

class DateProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path,version: 1,
        onCreate: (db,version)async{
      await db.execute('''
create table $tableDate ( 
  $tableDateId integer primary key autoincrement, 
  $tableDateMilli integer not null)
  ''');
        });
  }

  Future<Date> insert(Date date) async {
    date.id = await db.insert(tableDate, date.toMap());
    return date;
  }

  Future<Date> getDate(int id) async {
    List<Map> maps = await db.query(tableDate,
        columns: [tableDateId, tableDateMilli],
        where: "$tableDateId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Date.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableDate, where: "$tableDateId = ?", whereArgs: [id]);
  }

  Future<int> update(Date date) async {
    return await db.update(tableDate, date.toMap(),
        where: "$tableDateId = ?", whereArgs: [date.id]);
  }

  Future close() async => db.close();
}
