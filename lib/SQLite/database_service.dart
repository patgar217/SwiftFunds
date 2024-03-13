import 'package:sqflite/sqflite.dart';
import 'package:swiftfunds/Models/user.dart';
import 'package:swiftfunds/SQLite/database_helper.dart';

class DatabaseService {

  final dbHelper = DatabaseHelper();

  Future<bool> authenticate(User usr)async{
    final Database db = await dbHelper.initDB();
    var result = await db.rawQuery("select * from user where username = '${usr.username}' AND password = '${usr.password}' ");
    if(result.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  Future<int> createUser(User usr)async{
    final Database db = await dbHelper.initDB();
    return db.insert("user", usr.toMap());
  }

  Future<User?> getUser(String username)async{
    final Database db = await dbHelper.initDB();
    var res = await db.query("user",where: "username = ?", whereArgs: [username]);
    return res.isNotEmpty? User.fromMap(res.first):null;
  }

  
}