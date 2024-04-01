import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/Services/bill_service.dart';
import 'package:swiftfunds/Services/date_time_service.dart';
import 'package:swiftfunds/Views/home.dart';
import 'package:swiftfunds/main.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'SwiftFunds',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: primaryColor,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'SwiftFunds',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
    int days = int.parse(receivedNotification.payload!["days"]!);
    await createNextNotification(receivedNotification.id!, days);
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    MyApp.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  static Future<void> showNotification({
    required final int id,
    required final String title,
    required final String body,
    final String? summary,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    required DateTime scheduledTime, 
    required Map<String, String> payload,
  }) async {
    final now = DateTime.now();
    final notificationTime = scheduledTime.difference(now).inSeconds;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        payload: payload,
        summary: summary,
        icon: 'assets/logo.png',
      ),
      schedule: NotificationInterval(
        interval: notificationTime,
        timeZone:
            await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
      )
    );
  }

  static Future<void> createNextNotification(int billId, int days) async{
    final billService = BillService();
    Bill bill = await billService.getBillById(billId);
    if(days > 1) createNotificationFromBill(bill.id!, bill, bill.currentBiller!, days-1);
  }
  
  static Future<void> createNotificationFromBill(int billId, Bill bill, CurrentBiller currentBiller, int day) async {
    final dateTimeService = DateTimeService();
    DateTime specificDate = dateTimeService.subtractDaysFromDate(bill.dueDate, day);
    TimeOfDay specificTime = const TimeOfDay(hour: 10, minute: 0);
    DateTime scheduledTime = DateTime(
        specificDate.year,
        specificDate.month,
        specificDate.day,
        specificTime.hour,
        specificTime.minute,
      );

    await showNotification(
      id: billId,
      title: "${currentBiller.nickname} Bill is due in $day days.",
      body: "Pay your bills today to avoid additional charges",
      payload:{
        "days" : "3"
      },
      summary: 'SwiftFunds',
      scheduledTime: scheduledTime
    );
  }

  static Future<void> deleteNotification(int billId) async {
    await AwesomeNotifications().dismiss(billId);
  }

  static Future<void> editNotification(int billId, Bill bill, CurrentBiller currentBiller)async {
    await deleteNotification(billId);
    
    final dateTimeService = DateTimeService();
    int daysBeforeBill = dateTimeService.getDaysUntilDate(bill.dueDate);
    await createNotificationFromBill(billId, bill, currentBiller, daysBeforeBill > 3 ? 3 : daysBeforeBill);
  }
}

