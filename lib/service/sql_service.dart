import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ws54_flutter_speedrun4/service/data_model.dart';

class SqlBuild {
  static Database? database;
  static Future<Database> _initDatabase() async {
    database = await openDatabase(join(await getDatabasesPath(), "ws54.db"),
        onCreate: (db, version) async {
      await db.execute(
          "create table users (id text primary key, username text, account text, password text, birthday text)");
      await db.execute(
          "create table passwords (id text primary key, userID text, tag text, url text, login text, password text, isFav integer, foreign key (userID) references users (id) )");
    }, version: 1);
    return database!;
  }

  static Future<Database> getDBConnect() async {
    if (database != null) {
      return database!;
    } else {
      return await _initDatabase();
    }
  }
}

class UserDB {
  static Future<UserData> getUserDataByUserID(String userID) async {
    final Database database = await SqlBuild.getDBConnect();
    List<Map<String, dynamic>> maps =
        await database.query("users", where: "id = ?", whereArgs: [userID]);
    Map<String, dynamic> reuslt = maps.first;
    return UserData(reuslt["id"], reuslt["username"], reuslt["account"],
        reuslt['password'], reuslt['birthday']);
  }

  static Future<UserData> getUserDataByAccount(String account) async {
    final Database database = await SqlBuild.getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query("users", where: "account = ?", whereArgs: [account]);
    Map<String, dynamic> reuslt = maps.first;
    return UserData(reuslt["id"], reuslt["username"], reuslt["account"],
        reuslt['password'], reuslt['birthday']);
  }

  static Future<UserData> getUserDataByAccountAndPassword(
      String account, String password) async {
    final Database database = await SqlBuild.getDBConnect();
    List<Map<String, dynamic>> maps = await database.query("users",
        where: "account = ? AND password = ?", whereArgs: [account, password]);
    Map<String, dynamic> reuslt = maps.first;
    return UserData(reuslt["id"], reuslt["username"], reuslt["account"],
        reuslt['password'], reuslt['birthday']);
  }

  static Future<void> addUserData(UserData userData) async {
    final Database database = await SqlBuild.getDBConnect();
    database.insert("users", userData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateUserData(UserData userData) async {
    final Database database = await SqlBuild.getDBConnect();
    database.update("users", userData.toJson(),
        where: "id = ?",
        whereArgs: [userData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class PasswordDB {
  static Future<List<PasswordData>> getAllPasswordListDataByUserID(
      String userID) async {
    final Database database = await SqlBuild.getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query("passwords", where: "userID = ?", whereArgs: [userID]);
    return List.generate(maps.length, (index) {
      return PasswordData(
          maps[index]['id'],
          maps[index]['userID'],
          maps[index]['tag'],
          maps[index]['url'],
          maps[index]['login'],
          maps[index]['password'],
          maps[index]['isFav']);
    });
  }

  static Future<List<PasswordData>> getPasswordDataListByCondition(
    String userID,
    String tag,
    String url,
    String login,
    String password,
    String id,
    bool hasFav,
    int isFav,
  ) async {
    final Database database = await SqlBuild.getDBConnect();
    String whereCondition = "userID = ?";
    List whereArgs = [userID];

    if (tag.trim().isNotEmpty) {
      whereCondition += "and tag like ?";
      whereArgs.add("%$tag%");
    }
    if (url.trim().isNotEmpty) {
      whereCondition += "and url like ?";
      whereArgs.add("%$url%");
    }
    if (login.trim().isNotEmpty) {
      whereCondition += "and login like ?";
      whereArgs.add("%$login%");
    }
    if (password.trim().isNotEmpty) {
      whereCondition += "and password like ?";
      whereArgs.add("%$password%");
    }
    if (id.trim().isNotEmpty) {
      whereCondition += "and id like ?";
      whereArgs.add("%$id%");
    }
    if (hasFav) {
      whereCondition += "and isFav = ?";
      whereArgs.add(isFav);
    }

    List<Map<String, dynamic>> maps = await database.query("passwords",
        where: whereCondition, whereArgs: whereArgs);
    return List.generate(maps.length, (index) {
      return PasswordData(
          maps[index]['id'],
          maps[index]['userID'],
          maps[index]['tag'],
          maps[index]['url'],
          maps[index]['login'],
          maps[index]['password'],
          maps[index]['isFav']);
    });
  }

  static Future<void> addPasswordData(PasswordData passwordData) async {
    final Database database = await SqlBuild.getDBConnect();
    await database.insert("passwords", passwordData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updatePasswordData(PasswordData passwordData) async {
    final Database database = await SqlBuild.getDBConnect();
    await database.update("passwords", passwordData.toJson(),
        where: "id = ?",
        whereArgs: [passwordData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> remvoePasswordDataByPasswordID(String id) async {
    final Database database = await SqlBuild.getDBConnect();
    await database.delete("passwords", where: "id = ?", whereArgs: [id]);
  }
}
