import 'dart:convert';

import 'package:swiftfunds/Models/bill.dart';

Payment paymentFromMap(String str) => Payment.fromMap(json.decode(str));

String paymentToMap(Payment data) => json.encode(data.toMap());

class Payment {
    int? id;
    int userId;
    double totalAmount;
    double pointsEarned;
    double pointsRedeemed;
    String paymentDate;
    String status;
    List<Bill> bills;

    Payment({
        this.id,
        required this.userId,
        required this.totalAmount,
        required this.pointsEarned,
        required this.pointsRedeemed,
        required this.paymentDate,
        required this.status,
        required this.bills
    });

    factory Payment.fromMap(Map<String, dynamic> json) => Payment(
        id: json["id"],
        userId: json["userId"],
        totalAmount: json["totalAmount"].toDouble(),
        pointsEarned: json["pointsEarned"].toDouble(),
        pointsRedeemed: json["pointsRedeemed"].toDouble(),
        paymentDate: json["paymentDate"],
        status: json["status"],
        bills: []
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "totalAmount": totalAmount,
        "pointsEarned": pointsEarned,
        "pointsRedeemed": pointsRedeemed,
        "paymentDate": paymentDate,
        "status": status
    };
}