import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/item.dart';

class ItemsDatabase {
  static final ItemsDatabase instace = ItemsDatabase._init();

  static Database? _database;

  ItemsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase('items.db');
    return _database!;
  }

  Future<Database> _initDatabase(String filepath) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    // тут может нужно поменять для винды
    final path = join(documentsDirectory.path, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
    //здесь можно обновить
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
        CREATE TABLE $tableItems (
          ${ItemsFields.id} $idType,
          ${ItemsFields.name} $textType,
          ${ItemsFields.isImportant} $boolType,
          ${ItemsFields.time} $textType,
          )
          ''');
  }

  Future<Item> create(Item item) async {
    final db = await instace.database; // ссылка на бд
    final id = await db.insert(tableItems, item.toJson());
    return item.copy(id: id);
  }

  Future<Item> readSingleNote(int id) async {
    final db = await instace.database; // ссылка на бд

    final maps = await db.query(
      tableItems,
      columns: ItemsFields.values,
      where: '$ItemsFields.id} = ?',
      whereArgs: [id],
    ); // получаем json объекты, которые нужно развернуть

    if (maps.isNotEmpty) {
      return Item.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Item>> readAllNote() async {
    final db = await instace.database; // ссылка на бд
    final orderBy = '${ItemsFields.time} ASC';
    final result = await db.query(tableItems, orderBy: orderBy);
    return result.map((json) => Item.fromJson(json)).toList();
  }

  Future<int> update(Item item) async {
    final db = await instace.database;
    return db.update(
      tableItems,
      item.toJson(),
      where: '$ItemsFields.id} = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instace.database;

    return db.delete(
      tableItems,
      where: '$ItemsFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instace.database;
    db.close();
  }
}
