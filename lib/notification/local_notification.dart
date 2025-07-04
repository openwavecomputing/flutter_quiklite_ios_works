import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // static final onClickNotification = BehaviorSubject<String>();

// on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    // onClickNotification.add(notificationResponse.payload!);
  }

// initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    // request notification permissions
    /*_flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();*/

    /// below if condition copied from flutex.
    if (Platform.isAndroid) {
      // request notification permissions
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    } else if (Platform.isIOS) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions();
    }

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  /// added by surya to handle ios notification too
  static Future showSimpleNotification({
    required int notificationId,
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '10001',
      'QuikAllot Technician',
      channelDescription: 'QuikAllot Technician notification',
      importance: Importance.max,
      priority: Priority.high,
      autoCancel: true,
      ongoing: true,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // show a simple notification
/*  static Future showSimpleNotification({
    required int notificationId,
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('10001', 'QuikAllot Technician',
            channelDescription: 'QuikAllot Technician notification',
            importance: Importance.max,
            priority: Priority.high,
            autoCancel: true,
            ongoing: true,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
        notificationId, title, body, notificationDetails,
        payload: payload);
  }*/

  // close a specific channel notification
  static Future cancel(int notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // get all active notifications available
  static Future getActiveNotification() async {
    _flutterLocalNotificationsPlugin
        .getActiveNotifications()
        .then((listNotifications) {
      for (var element in listNotifications) {
        debugPrint("getActiveNotification id ${element.id}");
        debugPrint("getActiveNotification title ${element.title}");
        debugPrint("getActiveNotification body ${element.body}");
      }
    });
    await _flutterLocalNotificationsPlugin.getActiveNotifications();
  }

  // void initializeSettingsForScheduledNotificationAndPush(
  //     {required String notificationBody,
  //     required DateTime scheduledDateTime}) async {
  //   tz.initializeTimeZones();
  //   final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  //   debugPrint("currentTimeZone : $currentTimeZone");
  //   tz.setLocalLocation(tz.getLocation(currentTimeZone));
  //
  //   final updatedTime = tz.TZDateTime(
  //     tz.local,
  //     scheduledDateTime.year,
  //     scheduledDateTime.month,
  //     scheduledDateTime.day,
  //     scheduledDateTime.hour,
  //     scheduledDateTime.minute,
  //     scheduledDateTime.second,
  //   );
  //   if (updatedTime.isBefore(scheduledDateTime)) {
  //     debugPrint("Can't Schedule a remainder notification");
  //     return;
  //   }
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     '10002',
  //     'QuikAllot Technician',
  //     channelDescription: 'QuikAllot Technician notification',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     autoCancel: true,
  //     // ongoing: true,
  //     // ticker: 'ticker',
  //   );
  //
  //   const DarwinNotificationDetails iosNotificationDetails =
  //       DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //     interruptionLevel: InterruptionLevel.active,
  //   );
  //
  //   const NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: iosNotificationDetails,
  //   );
  //   await _flutterLocalNotificationsPlugin.zonedSchedule(
  //     ComparisonConstants.notificationIdScheduledRemainderNotification,
  //     WordConstants.wAppName,
  //     notificationBody,
  //     updatedTime,
  //     notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     // androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }
}
