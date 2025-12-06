import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/health_record_model.dart';

class HealthRecordDB {
  static final HealthRecordDB instance = HealthRecordDB._init();
  static Database? _database;

  HealthRecordDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health_records.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE health_records (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT,
      steps INTEGER,
      calories INTEGER,
      water INTEGER
    )
  ''');

  await db.insert("health_records", {
    "date": "2025-01-15",
    "steps": 8000,
    "calories": 320,
    "water": 1500,
  });

  await db.insert("health_records", {
    "date": "2025-01-14",
    "steps": 5500,
    "calories": 280,
    "water": 1000,
  });

  await db.insert("health_records", {
    "date": "2025-01-13",
    "steps": 10000,
    "calories": 410,
    "water": 1800,
  });
}


  Future<int> insertRecord(HealthRecord record) async {
    final db = await instance.database;
    return await db.insert('health_records', record.toMap());
  }

  Future<List<HealthRecord>> fetchAllRecords() async {
    final db = await instance.database;
    final result = await db.query('health_records');
    return result.map((e) => HealthRecord.fromMap(e)).toList();
  }

  Future<int> updateRecord(HealthRecord record) async {
    final db = await instance.database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
