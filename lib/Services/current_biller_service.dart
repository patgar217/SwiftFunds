import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/SQLite/database_service.dart';

class CurrentBillerService {

  final db = DatabaseService();

  Future<int> createCurrentBiller(Biller biller, int userId, String billName, String acctName, String acctNum) async{
    CurrentBiller currentBiller = CurrentBiller(userId: userId, billerId: biller.id, nickname: billName, acctName: acctName, acctNumber: acctNum, logo: biller.logo,);
    return await db.createCurrentBiller(currentBiller);
  }

  Future<int> updateCurrentBiller(CurrentBiller currentBiller, int userId, Biller biller, String billName, String acctName, String acctNum)async{
    CurrentBiller currentBiller = CurrentBiller(userId: userId, billerId: biller.id, nickname: billName, acctName: acctName, acctNumber: acctNum, logo: biller.logo,);
    return await db.updateCurrentBiller(currentBiller.id!, currentBiller);
  }

  Future<int> getBillsSize(CurrentBiller currentBiller) async {
    List<Bill> bills = await db.getBillsByCurrentBiller(currentBiller.id!);
    return bills.length;
  }

  Future<List<CurrentBiller>> getCurrentBillersByUserId(int loggedId) async {
    return await db.getCurrentBillersByUserId(loggedId);
  }
}