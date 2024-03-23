class NotificationModel {
    int? id;
    int billId;
    int dueDays;

    NotificationModel({
        this.id,
        required this.billId,
        required this.dueDays,
    });

    factory NotificationModel.fromMap(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        billId: json["billId"],
        dueDays: json["dueDays"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "billId": billId,
        "dueDays": dueDays,
    };
}