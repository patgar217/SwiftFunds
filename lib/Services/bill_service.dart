import 'package:intl/intl.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Services/current_biller_service.dart';

class BillService {

  final db = DatabaseService();
  
  final currentBillerService = CurrentBillerService();

  Future<int> addBillWithBiller(Biller biller, int userId, String billName, String acctName, String acctNum, String dueDate, double amount, bool isRepeat, String frequency, int noOfPayments) async {
    int currentBillerId = await currentBillerService.createCurrentBiller(biller, userId, billName, acctName, acctNum);

    Bill bill = Bill(currentBillerId: currentBillerId, userId: userId, dueDate: dueDate, amount: amount, status: "PENDING", isRepeating: isRepeat, frequency: frequency, noOfPayments: noOfPayments, noOfPaidPayments: 0);
    return await db.createBill(bill);
  }

  Future<int> addBillWithCurrentBiller(CurrentBiller currentBiller, int userId, String dueDate, double amount, bool isRepeat, String frequency, int noOfPayments) async {
    Bill bill = Bill(currentBillerId: currentBiller.id!, userId: userId, dueDate: dueDate, amount: amount, status: "PENDING", isRepeating: isRepeat, frequency: frequency, noOfPayments: noOfPayments, noOfPaidPayments: 0);
    return await db.createBill(bill);
  }

  Future<int> editBill(Bill bill, int userId, String dueDate, double amount, bool isRepeat, String frequency, int noOfPayments) async {
    return await db.updateBill(bill.id!, dueDate, amount, isRepeat, frequency, noOfPayments);
  }

  Future<int> deleteBill(Bill bill) async {
    return await db.deleteBill(bill.id!);
  }

  Future<List<Bill>> getPendingBills(int userId) async {
    List<Bill> bills = await db.getBillsByUserIdAndStatus(userId, "PENDING");

    bills.sort((a, b) {
      final dateFormatter = DateFormat('MM-dd-yyyy');
      final dateA = dateFormatter.parse(a.dueDate);
      final dateB = dateFormatter.parse(b.dueDate);
      return dateA.compareTo(dateB);
    });

    return bills;
  }

  Future<int> createBill(Bill bill) async {
    return await db.createBill(bill);
  }

  Future<int> createNextBill(Bill bill) async {
    CurrentBiller currentBiller = bill.currentBiller!;

    String nextDueDate = "";

    final format = DateFormat('MM-dd-yyyy');
    final DateTime date = format.parse(bill.dueDate);
    if(bill.frequency == "WEEKLY"){
      final nextDate = date.add(const Duration(days: 7));
      nextDueDate = format.format(nextDate);
    } else if(bill.frequency == "MONTHLY"){
      final nextDate = date.add(const Duration(days: 30));
      nextDueDate = format.format(nextDate);
    } else {
      final nextDate = date.add(const Duration(days: 90));
      nextDueDate = format.format(nextDate);
    }

    Bill newBill = Bill(currentBillerId: currentBiller.id!, userId: bill.userId, dueDate: nextDueDate, amount: bill.amount, status: "PENDING", isRepeating: bill.isRepeating, frequency:bill.frequency, noOfPayments: bill.noOfPayments, noOfPaidPayments: bill.noOfPaidPayments! + 1);
    return await createBill(newBill);
  }


}