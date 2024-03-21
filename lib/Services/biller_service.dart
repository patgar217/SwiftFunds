import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/SQLite/database_service.dart';

class BillerService {

  final db = DatabaseService();

  Future<List<Biller>> getBillersByCategory(int categoryId) async {
    return await db.getBillersByCategory(categoryId);
  }

  Future<Biller> getBiller(int billerId) async {
    return db.getBillerById(billerId);
  }

}