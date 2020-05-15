import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryService {

  static String guestName = "Guest";

  RepositoryService();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "impossiblocks.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          print("create version $version database");
      await db.execute(
          "CREATE TABLE ${UserRepository.table} ("
          "id integer primary key AUTOINCREMENT,"
          "color integer,"
          "avatar integer,"
          "name TEXT,"
          "coins integer"
          ");");
      await db.execute(
          "CREATE TABLE ${LevelRepository.table} ("
          "id integer primary key AUTOINCREMENT,"
          "userId integer,"
          "world integer,"
          "number integer,"
          "stars integer"
          ");");
      await db.execute(
          "INSERT INTO ${UserRepository.table} (name, coins, color, avatar) VALUES ('$guestName', 0, 0, 0)");
          print("created tables");
    });
  }

  Future<int> getUserCount() async {
    final db = await database;
    var response =
        await db.rawQuery("SELECT COUNT(*) FROM ${UserRepository.table}");
    if (response != null && response.isNotEmpty) {
      final Map<String, dynamic> firstRow = response.first;
      if (firstRow.isNotEmpty) {
        return int.tryParse(firstRow.values?.first) ?? 0;
      }
    }
    return 0;
  }

  Future<int> addUser(UserRepository user) async {
    final db = await database;
    var raw = await db.insert(
      UserRepository.table,
      user.toMapWithoutId(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<dynamic> addUsers(List<UserRepository> users) async {
    final db = await database;
    var batch = db.batch();
    users.forEach((user) {
      batch.insert(UserRepository.table, user.toMapWithoutId());
    });
    var raw = await batch.commit();
    return raw;
  }

  Future<int> updateUser(UserRepository user) async {
    final db = await database;
    var response = await db.update(UserRepository.table, user.toMapWithoutId(),
        where: "id = ?", whereArgs: [user.id]);
    return response;
  }

  Future<UserRepository> getUserWithId(int id) async {
    final db = await database;
    var response =
        await db.query(UserRepository.table, where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? UserRepository.fromMap(response.first) : null;
  }

  Future<UserRepository> getFirstUser() async {
    final db = await database;
    var response = await db.query(UserRepository.table);
    return response.isNotEmpty ? UserRepository.fromMap(response.first) : null;
  }

  Future<List<UserRepository>> getAllUsers() async {
    final db = await database;
    var response = await db.query(UserRepository.table);
    List<UserRepository> list =
        response.map((c) => UserRepository.fromMap(c)).toList();
    return list;
  }
  
  Future<int> addCoinsToUser(int userId, int coins) async {
    final db = await database;
    UserRepository user = await getUserWithId(userId);
    UserRepository userCoinsAdded = user.copyWith(coins: user.coins + coins);
    var response = await db.update(
        UserRepository.table, userCoinsAdded.toMapWithoutId(),
        where: "id = ?", whereArgs: [userCoinsAdded.id]);
    return response;
  }

  Future<int> deleteUserWithId(int id) async {
    final db = await database;
    return db.delete(UserRepository.table, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAllUsers() async {
    final db = await database;
    return db.delete(UserRepository.table);
  }

  Future<int> addLevel(LevelRepository level) async {
    final db = await database;
    var raw = await db.insert(
      LevelRepository.table,
      level.toMapWithoutId(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<dynamic> addLevels(List<LevelRepository> levels) async {
    final db = await database;
    var batch = db.batch();
    levels.forEach((level) {
      batch.insert(LevelRepository.table, level.toMapWithoutId());
    });
    var raw = await batch.commit();
    return raw;
  }

  Future<int> updateLevel(LevelRepository level) async {
    final db = await database;
    var response = await db.update(
        LevelRepository.table, level.toMapWithoutId(),
        where: "id = ?", whereArgs: [level.id]);
    return response;
  }

  Future<LevelRepository> getLevelWithId(int id) async {
    final db = await database;
    var response =
        await db.query(LevelRepository.table, where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? LevelRepository.fromMap(response.first) : null;
  }

  Future<LevelRepository> getLevel(int userId, int world, int number) async {
    final db = await database;
    var response =
        await db.query(LevelRepository.table, where: "userId = ? AND world = ? AND number = ?", whereArgs: [userId, world, number]);
    return response.isNotEmpty ? LevelRepository.fromMap(response.first) : null;
  }

  Future<List<LevelRepository>> getAllLevelsWithUserId(int userId) async {
    final db = await database;
    var response = await db
        .query(LevelRepository.table, where: "userId = ?", whereArgs: [userId]);
    List<LevelRepository> list =
        response.map((c) => LevelRepository.fromMap(c)).toList();
    return list;
  }

  Future<int> deleteLevelWithId(int id) async {
    final db = await database;
    return db.delete(LevelRepository.table, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAllUserLevels(int userId) async {
    final db = await database;
    return db.delete(LevelRepository.table, where: "userId = ?", whereArgs: [userId]);
  }

  Future<int> deleteAllLevels() async {
    final db = await database;
    return db.delete(LevelRepository.table);
  }
}
