import 'dart:convert';

CurrentBiller currentBillerFromMap(String str) => CurrentBiller.fromMap(json.decode(str));

String currentBillerToMap(CurrentBiller data) => json.encode(data.toMap());

class CurrentBiller {
    int? id;
    int userId;
    int billerId;
    String nickname;
    String acctName;
    String acctNumber;
    String? acctType;
    bool isRepeating;
    String? frequency;
    int? noOfPayments;

    CurrentBiller({
        this.id,
        required this.userId,
        required this.billerId,
        required this.nickname,
        required this.acctName,
        required this.acctNumber,
        this.acctType,
        required this.isRepeating,
        this.frequency,
        this.noOfPayments,
    });

    factory CurrentBiller.fromMap(Map<String, dynamic> json) => CurrentBiller(
        id: json["id"],
        userId: json["userId"],
        billerId: json["billerId"],
        nickname: json["nickname"],
        acctName: json["acctName"],
        acctNumber: json["acctNumber"],
        acctType: json["acctType"],
        isRepeating: json["isRepeating"],
        frequency: json["frequency"],
        noOfPayments: json["noOfPayments"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "billerId": billerId,
        "nickname": nickname,
        "acctName": acctName,
        "acctNumber": acctNumber,
        "acctType": acctType,
        "isRepeating": isRepeating,
        "frequency": frequency,
        "noOfPayments": noOfPayments,
    };
}