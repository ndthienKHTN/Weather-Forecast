import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/weather_history.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('weather_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE weather_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city TEXT NOT NULL,
        search_time TEXT NOT NULL,
        weather_data TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertHistory(WeatherHistory history) async {
    final db = await database;
    await db.insert(
      'weather_history',
      {
        'city': history.city,
        'search_time': history.searchTime.toIso8601String(),
        'weather_data': jsonEncode(history.weatherData.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WeatherHistory>> getHistoryForToday() async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay =
        DateTime(today.year, today.month, today.day).toIso8601String();

    final List<Map<String, dynamic>> maps = await db.query(
      'weather_history',
      where: 'search_time >= ?',
      whereArgs: [startOfDay],
      orderBy: 'search_time DESC',
    );

    return maps.map((map) => WeatherHistory.fromJson(map)).toList();
  }

  Future<void> deleteOldHistory() async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay =
        DateTime(today.year, today.month, today.day).toIso8601String();

    await db.delete(
      'weather_history',
      where: 'search_time < ?',
      whereArgs: [startOfDay],
    );
  }

  Future<void> deleteHistoryItem(int id) async {
    final db = await database;
    await db.delete(
      'weather_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteHistoryBySearch(String city, DateTime searchTime) async {
    final db = await database;
    await db.delete(
      'weather_history',
      where: 'city = ? AND search_time = ?',
      whereArgs: [city, searchTime.toIso8601String()],
    );
  }

  Future<void> deleteAllTodayHistory() async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay =
        DateTime(today.year, today.month, today.day).toIso8601String();

    await db.delete(
      'weather_history',
      where: 'search_time >= ?',
      whereArgs: [startOfDay],
    );
  }
}
