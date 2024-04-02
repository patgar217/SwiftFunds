import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Models/notification_setting.dart';
import 'package:swiftfunds/Services/notification_service.dart';
import 'package:swiftfunds/Services/notification_setting_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSettingsLoaded = false;
  bool isNotificationsOn = true;
  late NotificationSetting notificationSetting;
  int scheduledDays = 3;
  TimeOfDay timeOfDay = const TimeOfDay(hour: 10, minute: 0);
  List<int> days = [1, 2, 3];

  final notificationSettingService = NotificationSettingService();
  
  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  loadSettings() async {
    notificationSetting = await notificationSettingService.getSettingOfCurrentUser();
  
    setState(() {
      isSettingsLoaded = true;
      isNotificationsOn = notificationSetting.sendNotifications;
      timeOfDay = TimeOfDay(hour: notificationSetting.scheduledHour, minute: notificationSetting.scheduledMinute);
      scheduledDays = notificationSetting.scheduledDays;
    });
  }

  Future<void> toggleNotification(bool value) async {
    setState(() {
      isNotificationsOn = value;
    });
    notificationSettingService.updateSettingOfCurrentUser(value, timeOfDay.hour, timeOfDay.minute, scheduledDays);

    if(!value){
      NotificationService.deleteAllNotifications();
    }
  }

  Future<void> selectTime() async {
    TimeOfDay? timePicked = await showTimePicker(
      context: context, initialTime: timeOfDay
    );

    if(timePicked != null){
      setState(() {
        timeOfDay = timePicked;
      });
      notificationSettingService.updateSettingOfCurrentUser(isNotificationsOn, timePicked.hour, timePicked.minute, scheduledDays);
      NotificationService.editAllNotifications();
    }
  }

  Future<void> selectDay(int day) async {
    setState(() {
      scheduledDays = day;
    });
    notificationSettingService.updateSettingOfCurrentUser(isNotificationsOn, timeOfDay.hour, timeOfDay.minute, day);
    NotificationService.editAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
   
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      height: 60,
                    ),
                    Positioned(
                      top: 20,
                      left: size.width * .05,
                      child: const Text("Settings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                    ),
                    Positioned(
                      top: 70,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        child: SizedBox(
                          width: size.width * .9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Notification Settings", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                              const SizedBox(height: 15,),
                              Row(
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: [
                                      Text("Push Notification", style: TextStyle(fontSize: 15),),
                                      Text("Receive reminders when bills are almost due.", style: TextStyle(fontSize: 10),),
                                    ],
                                  ),
                                  const Spacer(),
                                  Transform.scale(
                                    scale: 0.7,
                                    child: CupertinoSwitch(
                                      value: isNotificationsOn,
                                      onChanged: (value) { 
                                        toggleNotification(value);
                                      },
                                      activeColor: secondaryDark,
                                      trackColor: const Color.fromARGB(255, 214, 214, 214),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15,),
                              if(isNotificationsOn) Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: [
                                      Text("Notification Time", style: TextStyle(fontSize: 15),),
                                      Text("Scheduled time when notifications are sent.", style: TextStyle(fontSize: 10),),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 43,
                                    transformAlignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: primaryLightest, 
                                      border: Border.all( // Add a border around all sides
                                        color: primaryDark, // Set the desired border color
                                        width: 1, // Optional: Set the border width (default is 1.0)
                                      ),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: TextButton(
                                      onPressed: ()async{await selectTime();}, 
                                      child: Text(timeOfDay.format(context), style: const TextStyle(fontSize: 20, color: primaryDark),),),
                                  )
                              
                                ]
                              ),
                              const SizedBox(height: 15,),
                              if(isNotificationsOn) Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: [
                                      Text("Remind Days before Due", style: TextStyle(fontSize: 15),),
                                      Text("Reminders are sent days before its due date.", style: TextStyle(fontSize: 10),),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 110,
                                    height: 43,
                                    transformAlignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: primaryLightest, 
                                      border: Border.all( // Add a border around all sides
                                        color: primaryDark, // Set the desired border color
                                        width: 1, // Optional: Set the border width (default is 1.0)
                                      ),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: scheduledDays,
                                        onChanged: (int? newValue) {
                                          selectDay(newValue?? 3);
                                        },
                                        items: days.map((int kv) {
                                          return DropdownMenuItem<int>(
                                            value: kv,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: Text(kv.toString() + (kv == 1 ? ' day' : ' days'), textAlign: TextAlign.center ,style: const TextStyle(fontSize: 20, color: primaryDark)),
                                            ),
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                      )
                                    ),
                                  )
                              
                                ]
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}