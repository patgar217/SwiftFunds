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
    bool isRepeating;
    String? frequency;
    int? noOfPayments;
    int? noOfPaidPayments;

    Bill({
        this.id,
        required this.userId,
        required this.currentBillerId,
        required this.dueDate,
        required this.amount,
        required this.status,
        this.currentBiller,
        required this.isRepeating,
        this.frequency,
        this.noOfPayments,
        this.noOfPaidPayments,
    });

    factory Bill.fromMap(Map<String, dynamic> json) => Bill(
        id: json["id"],
        userId: json["userId"],
        currentBillerId: json["currentBillerId"],
        dueDate: json["dueDate"],
        amount: json["amount"],
        status: json["status"],
        isRepeating: json["isRepeating"] == 0 ? false : true,
        frequency: json["frequency"],
        noOfPayments: json["noOfPayments"],
        noOfPaidPayments: json["noOfPaidPayments"]
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "currentBillerId": currentBillerId,
        "dueDate": dueDate,
        "amount": amount,
        "status": status,
        "isRepeating": isRepeating ? 1 : 0,
        "frequency": frequency,
        "noOfPayments": noOfPayments,
        "noOfPaidPayments": noOfPaidPayments
    };
}