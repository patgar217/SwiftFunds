import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Services/current_biller_service.dart';
import 'package:swiftfunds/Services/date_time_service.dart';
import 'package:swiftfunds/Services/notification_service.dart';

class BillService {

  final db = DatabaseService();
  final currentBillerService = CurrentBillerService();
  final dateTimeService = DateTimeService();

  Future<int> addBillWithBiller(Biller biller, int userId, String billName, String acctName, String acctNum, String dueDate, double amount, bool isRepeat, String frequency, int noOfPayments) async {
    int currentBillerId = await currentBillerService.createCurrentBiller(biller, userId, billName, acctName, acctNum);

    Bill bill = Bill(currentBillerId: currentBillerId, userId: userId, dueDate: dueDate, amount: amount, status: "PENDING", isRepeating: isRepeat, frequency: frequency, noOfPayments: noOfPayments, noOfPaidPayments: 0);
    return await createBill(bill);
  }

  Future<int> addBillWithCurrentBiller(CurrentBiller currentBiller, int userId, String dueDate, double amount, bool isRepeat, String frequency, int noOfPayments) async {
    Bill bill = Bill(currentBillerId: currentBiller.id!, userId: userId, dueDate: dueDate, amount: amount, status: "PENDING", isRepeating: isRepeat, frequency: frequency, noOfPayments: noOfPayments, noOfPaidPayments: 0);
    return await createBill(bill);
  }

  Future<int> editBill(Bill bill, int userId, String dueDate, double amount, bool isRepeat, String frequency, int noOfPayments) async {
    int res = await db.updateBill(bill.id!, dueDate, amount, isRepeat, frequency, noOfPayments);
    bill.dueDate = dueDate;
    CurrentBiller currentBiller = await db.getCurrentBiller(bill.currentBillerId);
    await NotificationService.editNotification(bill.id!, bill, currentBiller);
    return res;
  }

  Future<int> deleteBill(Bill bill) async {
    return await db.deleteBill(bill.id!);
  }

  Future<List<Bill>> getPendingBills(int userId) async {
    List<Bill> bills = await db.getBillsByUserIdAndStatus(userId, "PENDING");

    bills.sort((a, b) {
      final dateA = dateTimeService.convertStringToNumberFormat(a.dueDate);
      final dateB = dateTimeService.convertStringToNumberFormat(b.dueDate);
      return dateA.compareTo(dateB);
    });

    return bills;
  }

  Future<Bill> getBillById(int billId) async {
    return await db.getBill(billId);
  }

  Future<int> createBill(Bill bill) async {
    int billId = await db.createBill(bill);
    CurrentBiller currentBiller = await db.getCurrentBiller(bill.currentBillerId);
    
    int daysBeforeBill = dateTimeService.getDaysUntilDate(bill.dueDate);
    await NotificationService.createNotificationFromBill(billId, bill, currentBiller, daysBeforeBill > 3 ? 3 : daysBeforeBill);
    return billId;
  }

  Future<int> createNextBill(Bill bill) async {
    CurrentBiller currentBiller = bill.currentBiller!;

    String nextDueDate = "";

    if(bill.frequency == "WEEKLY"){
      nextDueDate = dateTimeService.addDaysFromDate(bill.dueDate, 7);
    } else if(bill.frequency == "MONTHLY"){
      nextDueDate = dateTimeService.addDaysFromDate(bill.dueDate, 30);
    } else {
      nextDueDate = dateTimeService.addDaysFromDate(bill.dueDate, 90);
    }

    Bill newBill = Bill(currentBillerId: currentBiller.id!, userId: bill.userId, dueDate: nextDueDate, amount: bill.amount, status: "PENDING", isRepeating: bill.isRepeating, frequency:bill.frequency, noOfPayments: bill.noOfPayments, noOfPaidPayments: bill.noOfPaidPayments! + 1);
    return await createBill(newBill);
  }


}