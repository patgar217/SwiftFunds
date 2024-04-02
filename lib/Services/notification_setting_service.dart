
import 'package:swiftfunds/Models/notification_setting.dart';
import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Services/authentication_service.dart';

class NotificationSettingService {

  final db = DatabaseService();
  final authService = AuthenticationService();

  Future<NotificationSetting> getSettingOfCurrentUser() async{
    int? loggedId = await authService.getLoggedId();

    if(loggedId != null){
      return await db.getNotificationSetting(loggedId);
    }
    return NotificationSetting.defaultNotification();
  }

  Future<int> createSetting(int userId, bool sendNotifications, int scheduledHour, int scheduledMinute,int scheduledDays ) async{
    NotificationSetting notificationSetting = NotificationSetting(userId: userId, sendNotifications: sendNotifications, scheduledHour: scheduledHour, scheduledMinute: scheduledMinute, scheduledDays: scheduledDays);
    return await db.createNotificationSetting(notificationSetting);
  }

  Future<int> createDefaultSetting(int userId) async{
    NotificationSetting notificationSetting = NotificationSetting.defaultNotification();
    notificationSetting.userId = userId;
    return await db.createNotificationSetting(notificationSetting);
  }

  Future<int> updateSetting(int userId, bool sendNotifications, int scheduledHour, int scheduledMinute,int scheduledDays ) async{
    return await db.updateNotificationSetting(userId, sendNotifications, scheduledHour, scheduledMinute, scheduledDays);
  }

  Future<int> updateSettingOfCurrentUser(bool sendNotifications, int scheduledHour, int scheduledMinute,int scheduledDays ) async{
    int? loggedId = await authService.getLoggedId();

    if(loggedId != null){
      return await db.updateNotificationSetting(loggedId, sendNotifications, scheduledHour, scheduledMinute, scheduledDays);
    }
    return 0;
  }

}