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
    String logo;

    CurrentBiller({
        this.id,
        required this.userId,
        required this.billerId,
        required this.nickname,
        required this.acctName,
        required this.acctNumber,
        required this.logo,
    });

    factory CurrentBiller.fromMap(Map<String, dynamic> json) => CurrentBiller(
        id: json["id"],
        userId: json["userId"],
        billerId: json["billerId"],
        nickname: json["nickname"],
        acctName: json["acctName"],
        acctNumber: json["acctNumber"],
        logo: json["logo"] ?? "",
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "billerId": billerId,
        "nickname": nickname,
        "acctName": acctName,
        "acctNumber": acctNumber,
        "logo":logo,
    };
}