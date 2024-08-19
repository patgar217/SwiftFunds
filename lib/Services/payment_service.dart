import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/payment.dart';
import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Services/date_time_service.dart';
import 'package:swiftfunds/Services/notification_service.dart';

class PaymentService {
  
  final db = DatabaseService();
  final dateTimeService = DateTimeService();

  Future<Payment> createPayment(Payment payment) async {
    return await db.createPayment(payment);
  }

  Future<Payment> createPendingPayment(int userId, double totalAmount, bool isRedeem, double pointsRedeemed, List<Bill> bills, double totalWithPoints) async {
    Payment initialPayment =  Payment(
      userId: userId, 
      totalAmount: totalAmount,
      pointsEarned: 0.00,
      pointsRedeemed: isRedeem ? pointsRedeemed : 0.00,
      paymentDate: "",
      status: "PENDING",
      bills: bills,
      totalAmountWithPoints: totalWithPoints
    );

    return await createPayment(initialPayment);
  }

  Future<List<Payment>> getPayments(int userId) async {
    return await db.getPayments(userId);
  }

  Future<Payment> updatePayment(Payment payment, bool isSuccess) async {
    DateTime now = DateTime.now();
    String formattedDateTime = dateTimeService.convertWordFormatToString(now);

    Payment updatedPayment = payment;
    updatedPayment.paymentDate = formattedDateTime;
    updatedPayment.pointsEarned = isSuccess ? payment.totalAmount * 0.001 : 0.00;
    updatedPayment.pointsRedeemed = isSuccess ? payment.pointsRedeemed : 0.00;
    updatedPayment.status = isSuccess ? "SUCCESS" : "FAILED";

    await db.updatePayment(updatedPayment.id!, updatedPayment);

    if(isSuccess){
      for (var bill in payment.bills) {
        await NotificationService.deleteNotification(bill.id!);
      }
    }
    return updatedPayment;
  }
}