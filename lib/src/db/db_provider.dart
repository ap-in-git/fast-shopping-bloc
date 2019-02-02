import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/ShoppingItem.dart';
import 'package:path/path.dart';
import 'dart:io' show Directory;
import 'dart:async' show Future;

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  DBProvider() {
    initDB();
  }

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'items.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database newDb, int version) {
      newDb.execute("""
        Create table items (
          id Integer Primary Key,
          name text,
          completed bit
         )
        """);
    });
  }

  Future<List<ShoppingItem>> getShoppingItems() async {
    final db = await database;
    var res = await db.query('items');
    List<ShoppingItem> list =
        res.isNotEmpty ? res.map((i) => ShoppingItem.fromJson(i)).toList() : [];
    return list;
  }

  Future<int> insertShoppingItem(ShoppingItem shoppingItem) async {
    final db = await database;
    return db.insert('items', shoppingItem.toJson());
  }

  void alterShoppingItem(ShoppingItem shoppingItem) async {
    final db = await database;
    db.update('items', shoppingItem.toJson(),
        where: "id = ? ", whereArgs: [shoppingItem.id]);
  }

  void deleteShoppingItem(int id) async {
    final db = await database;
    db.delete('items', where: 'id=?', whereArgs: [id]);
  }
}
