import 'dart:convert';

import 'package:swiftfunds/Models/bill.dart';

Payment paymentFromMap(String str) => Payment.fromMap(json.decode(str));

String paymentToMap(Payment data) => json.encode(data.toMap());

class Payment {
    int? id;
    int userId;
    int totalAmount;
    double pointsEarned;
    double pointsRedeemed;
    int? receiptNo;
    String paymentDate;
    List<Bill> bills;

    Payment({
        this.id,
        required this.userId,
        required this.totalAmount,
        required this.pointsEarned,
        required this.pointsRedeemed,
        this.receiptNo,
        required this.paymentDate,
        required this.bills
    });

    factory Payment.fromMap(Map<String, dynamic> json) => Payment(
        id: json["id"],
        userId: json["userId"],
        totalAmount: json["totalAmount"],
        pointsEarned: json["pointsEarned"].toDouble(),
        pointsRedeemed: json["pointsRedeemed"],
        receiptNo: json["receiptNo"],
        paymentDate: json["paymentDate"],
        bills: json["bills"]
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "totalAmount": totalAmount,
        "pointsEarned": pointsEarned,
        "pointsRedeemed": pointsRedeemed,
        "receiptNo": receiptNo,
        "paymentDate": paymentDate,
        "bills": bills
    };
}