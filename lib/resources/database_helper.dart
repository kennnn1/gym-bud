import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sleep_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sleep_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bedtime TEXT,
            wakeup_time TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertSleepData(String bedtime, String wakeupTime) async {
    final db = await database;
    return await db.insert('sleep_data', {
      'bedtime': bedtime,
      'wakeup_time': wakeupTime,
    });
  }

  Future<List<Map<String, dynamic>>> getSleepHistory() async {
    final db = await database;
    return await db.query('sleep_data', orderBy: 'id DESC');
  }
}
