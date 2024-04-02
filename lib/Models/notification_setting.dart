import 'dart:convert';

NotificationSetting notificationSettingFromMap(String str) => NotificationSetting.fromMap(json.decode(str));

String notificationSettingToMap(NotificationSetting data) => json.encode(data.toMap());

class NotificationSetting {
    int? id;
    int userId;
    bool sendNotifications;
    int scheduledHour;
    int scheduledMinute;
    int scheduledDays;

    NotificationSetting({
        this.id,
        required this.userId,
        required this.sendNotifications,
        required this.scheduledHour,
        required this.scheduledMinute,
        required this.scheduledDays,
    });

    factory NotificationSetting.fromMap(Map<String, dynamic> json) => NotificationSetting(
        id: json["id"],
        userId: json["userId"],
        sendNotifications: json["sendNotifications"] == 0 ? false : true,
        scheduledHour: json["scheduledHour"],
        scheduledMinute: json["scheduledMinute"],
        scheduledDays: json["scheduledDays"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "userId": userId,
        "sendNotifications": sendNotifications ? 1 : 0,
        "scheduledHour": scheduledHour,
        "scheduledMinute": scheduledMinute,
        "scheduledDays": scheduledDays,
    };

    static NotificationSetting defaultNotification(){
      return NotificationSetting(userId: 0, sendNotifications: true, scheduledHour: 10, scheduledMinute: 0, scheduledDays: 3);
    }
}