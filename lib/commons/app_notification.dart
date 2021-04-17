import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AppNotification {
  AppNotification._();

  static final FlutterLocalNotificationsPlugin _instance =
      FlutterLocalNotificationsPlugin();

  static final NotificationDetails platformChannelSpecifics =
      NotificationDetails(
    android: AndroidNotificationDetails(
      'lotto mate notification id',
      'scheduled notification',
      'scheduled notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    ),
  );

  static initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _instance.initialize(initializationSettings);
  }

  static zonedSchedule(
      String title, String body, tz.TZDateTime scheduledDate) async {
    await _instance.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      payload: 'item x',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
