import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftfunds/Models/user.dart';
import 'package:swiftfunds/Services/user_service.dart';

class AuthenticationService {
  
  final userService = UserService();
  
  Future<int?> getLoggedId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("loggedId");
  }

  void setLoggedUser(String userName, int userId) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("loggedId", userId);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("loggedId");
  }

  Future<User?> getCurrentUser() async {
    int? loggedId = await getLoggedId();
    if (loggedId != null){
      return userService.getUserById(loggedId);
    }
    return null;
  }
}