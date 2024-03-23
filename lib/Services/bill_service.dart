import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/Models/notification.dart';
import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Services/current_biller_service.dart';
import 'package:swiftfunds/Services/date_time_service.dart';

class BillService {

  final db = DatabaseService();

  final dateTimeService = DateTimeService();
  
  final currentBillerService = CurrentBillerService();

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
    return await db.updateBill(bill.id!, dueDate, amount, isRepeat, frequency, noOfPayments);
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

  Future<int> createBill(Bill bill) async {
    var res = await db.createBill(bill);
    CurrentBiller currentBiller = await db.getCurrentBiller(bill.currentBillerId);
    for (int day = 1; day < 4; day++) {
      
      int notifId = await db.createNotification(NotificationModel(billId: res, dueDays: day));

      // DateTime specificDate = dateTimeService.subtractDaysFromDate(bill.dueDate, day);
      // TimeOfDay specificTime = const TimeOfDay(hour: 10, minute: 0);
      // DateTime desiredDateTime = DateTime(
      //   specificDate.year,
      //   specificDate.month,
      //   specificDate.day,
      //   specificTime.hour,
      //   specificTime.minute,
      // );

      DateTime now = DateTime.now();
      DateTime desiredDateTime = now.add(Duration(seconds: day + 5));
      // notificationService.scheduleNotification(
      //   title: "${currentBiller.nickname} Bill is due in $day days.",
      //   body: "Pay your bills today to avoid additional charges",
      //   scheduledNotificationDateTime: desiredDateTime,
      //   id: notifId
      // );
    }
    
    return res;
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