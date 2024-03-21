import 'package:swiftfunds/Models/user.dart';
import 'package:swiftfunds/SQLite/database_service.dart';

class UserService{

  final db = DatabaseService();

  Future<User?> getUserByUsername(String username) async {
    return await db.getUser(username);
  }

  Future<User> getUserById(int userId) async {
    return await db.getUserById(userId);
  }

  Future<int> createNewUser(String fullName, String email, String username, String password) async {
    return await db.createUser(User(fullName: fullName,email: email,username: username, password: password, swiftpoints: 0.00));
  }

  Future<bool> hasDuplicateEmail(String email) async {
    User? user = await db.getUserByField("email", email);
    return user != null;
  }

  Future<bool> hasDuplicateUsername(String username) async {
    User? user = await db.getUserByField("username", username);
    return user != null;
  }

  void updateSwiftPoint(int userId, double pointsEarned, double pointsRedeemed) async {
    await db.updateUserPoints(userId, pointsEarned, pointsRedeemed);
  }
}
