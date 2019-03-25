import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'units.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'ID';
  static const String TEMPERATURE = 'temperature';
  static const String WEIGHT = 'weight';
  static const String TABLE = 'Units';
  static const String DB_NAME = 'units.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER, $TEMPERATURE TEXT, $WEIGHT TEXT)");
  }

  Future<Units> save(Units units) async {
    var dbClient = await db;
    units.id = await dbClient.insert(TABLE, units.toMap());
    return units;
  }

  Future<List<Units>> getTemp() async {
    var dbClient = await db;
    List<Units> temp;
    List<Map> maps =
      await dbClient.query(TABLE, columns: [ID, TEMPERATURE, WEIGHT]);
    List<Units> units = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        units.add(Units.fromMap(maps[i]));
      }
    }
    return units;
  }

  Future<List<Units>> getTemperature() async {
    var dbClient = await db;
    List<Units> temp;
    try {
      List<Map> maps =
        await dbClient.query(TABLE, columns: [ID, TEMPERATURE, WEIGHT]);
      List<Units> units = [];
      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          units.add(Units.fromMap(maps[i]));
        }
      }
      temp = [maps[0][TEMPERATURE]];
      print(temp);
      return units;
    } catch (e) {
      await dbClient.transaction((txn) async {
        var query =
            "INSERT INTO $TABLE ($ID, $TEMPERATURE, $WEIGHT) VALUES (0, 'celcius', 'gr')";
        await txn.rawInsert(query);
        List<Map> maps =
          await dbClient.query(TABLE, columns: [ID, TEMPERATURE, WEIGHT]);
        List<Units> units = [];
        if (maps.length > 0) {
          for (int i = 0; i < maps.length; i++) {
            units.add(Units.fromMap(maps[i]));
          }
        }
      temp = [maps[0][TEMPERATURE]];
      print(temp);
      return units;
      });
    }
  }  
  /*
  Future<String> getTemperature() async {
    var dbClient = await db;
    String temp;
    try {
      List<Map> maps =
          await dbClient.query(TABLE, columns: [ID, TEMPERATURE, WEIGHT]);
      temp = maps[0][TEMPERATURE];
    } catch (e) {
      await dbClient.transaction((txn) async {
        var query =
            "INSERT INTO $TABLE ($ID, $TEMPERATURE, $WEIGHT) VALUES (0, 'celcius', 'gr')";
        await txn.rawInsert(query);
        temp = 'celcius';
      });
    }
    return temp;
  }*/

  Future<String> setTemperature(String temp) async {
    var dbClient = await db;
      await dbClient.transaction((txn) async {
        var query =
            "UPDATE $TABLE SET $TEMPERATURE = ? WHERE $ID = ?";
        await txn.rawInsert(query, [temp, 0]);
      });
    return temp;
  }

  Future<List<Units>> getUnits() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(TABLE, columns: [ID, TEMPERATURE, WEIGHT]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Units> units = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        units.add(Units.fromMap(maps[0]));
      }
    }
    return units;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Units units) async {
    var dbClient = await db;
    return await dbClient
        .update(TABLE, units.toMap(), where: '$ID = ?', whereArgs: [units.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
