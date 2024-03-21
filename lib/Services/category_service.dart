import 'package:swiftfunds/Models/category.dart';
import 'package:swiftfunds/SQLite/database_service.dart';

class CategoryService{

  final db = DatabaseService();

  Future<List<Category>> getCategories() async {
    return db.getCategories();
  }
}