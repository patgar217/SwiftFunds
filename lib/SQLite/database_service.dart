import 'package:sqflite/sqflite.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/Models/category.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/Models/payment.dart';
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

  Future<User> getUserById(int id)async{
    final Database db = await dbHelper.initDB();
    var res = await db.query("user",where: "userId = ?", whereArgs: [id]);
    return User.fromMap(res.first);
  }

  Future<int?> updateUserPoints(int id, double pointsEarned, double pointsRedeemed)async{
    final Database db = await dbHelper.initDB();

    User user = await getUserById(id);
    double points = user.swiftpoints! + pointsEarned - pointsRedeemed;

    return db.update(
          "user",
          {
            "swiftpoints": points,
          },
          where: "userId = ?",
          whereArgs: [id],
        );

  }

  Future<List<Category>> getCategories() async {
    final Database db = await dbHelper.initDB();
    final maps = await db.query(
      "category",
    );
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<List<Biller>> getBillersByCategory(int categoryId) async {
    final Database db = await dbHelper.initDB();
    final maps = await db.query(
      "biller",
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    return List.generate(maps.length, (i) => Biller.fromMap(maps[i]));
  }

  Future<List<Bill>> getBills(int userId) async {
    final Database db = await dbHelper.initDB();
    final maps = await db.query(
      "bill",
      where: 'userId = ?',
      whereArgs: [userId],
    );
    List<Bill> bills = List.generate(maps.length, (i) => Bill.fromMap(maps[i]));
    List<CurrentBiller> currentBillers = await getCurrentBillersByUserId(userId);

    for(final bill in bills){
      bill.currentBiller = currentBillers.firstWhere((currBiller) => currBiller.id! == bill.currentBillerId);
    }

    return bills;

  }

  Future<List<Bill>> getBillsByUserIdAndStatus(int userId, String status) async {
    final Database db = await dbHelper.initDB();
    final maps = await db.query(
      "bill",
      where: 'userId = ? AND status = ?',
    whereArgs: [userId, status],
    );
    
    List<Bill> bills = List.generate(maps.length, (i) => Bill.fromMap(maps[i]));
    List<CurrentBiller> currentBillers = await getCurrentBillersByUserId(userId);

    for(final bill in bills){
      bill.currentBiller = currentBillers.firstWhere((currBiller) => currBiller.id! == bill.currentBillerId);
    }

    return bills;
  }

  Future<double> getTotalPendingBills(int userId) async {
    List<Bill> bills = await getBillsByUserIdAndStatus(userId, "PENDING");
    double total = 0.0;
    for (var bill in bills) {
      total += bill.amount;
    }
    return total;
  }

  Future<CurrentBiller> getCurrentBiller(int id)async{
    final Database db = await dbHelper.initDB();
    var res = await db.query("currentBiller",where: "id = ?", whereArgs: [id]);
    return CurrentBiller.fromMap(res.first);
  }

  Future<List<CurrentBiller>> getCurrentBillersByUserId(int userId) async {
    final Database db = await dbHelper.initDB();
    final maps = await db.query(
      "currentBiller",
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => CurrentBiller.fromMap(maps[i]));
  }

  Future<Payment> createPayment(Payment payment) async {
    final Database db = await dbHelper.initDB();
    final id = await db.insert("payment", payment.toMap());

    for (final bill in payment.bills) {
      await db.insert('paymentBill', {"paymentId" : id, "billId" : bill.id});
    }

    return db.query("payment", where: "id = ?", whereArgs: [id]).then((rows) {
      if (rows.isNotEmpty) {
        return Payment.fromMap(rows.first);
      } else {
        throw Exception("Payment not found after insertion"); // Handle error
      }
    });
  }

  Future<int> updatePayment(int id, Payment payment) async {
    final Database db = await dbHelper.initDB();
    final updateMap = payment.toMap(); // Get all fields from the updatedPayment object
    updateMap.removeWhere((key, value) => key == 'id'); // Exclude the ID from the update
    
    var res = db.update(
      "payment",
      updateMap,
      where: "id = ?",
      whereArgs: [id],
    );

    if(payment.status =="SUCCESS"){
      for(final bill in payment.bills){
        db.update(
          "bill",
          {
            "status": "PAID",
          },
          where: "id = ?",
          whereArgs: [bill.id],
        );

      }
    }

    return res;
  }


}