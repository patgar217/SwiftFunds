import 'dart:convert';

import 'package:swiftfunds/Models/current_biller.dart';

Bill billFromMap(String str) => Bill.fromMap(json.decode(str));

String billToMap(Bill data) => json.encode(data.toMap());

class Bill {
    int? id;
    int userId;
    int currentBillerId;
    String dueDate;
    double amount;
    String status;
    CurrentBiller? currentBiller;

    Bill({
        this.id,
        required this.userId,
        required this.currentBillerId,
        required this.dueDate,
        required this.amount,
        required this.status,
        this.currentBiller
    });

    factory Bill.fromMap(Map<String, dynamic> json) => Bill(
        id: json["id"],
        userId: json["userId"],
        currentBillerId: json["currentBillerId"],
        dueDate: json["dueDate"],
        amount: json["amount"],
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "currentBillerId": currentBillerId,
        "dueDate": dueDate,
        "amount": amount,
        "status": status,
    };
}