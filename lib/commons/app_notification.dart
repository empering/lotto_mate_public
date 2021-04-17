import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lotto_mate/commons/app_constant.dart';
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

  static zonedSchedule({
    required String title,
    required String body,
    tz.TZDateTime? scheduledDate,
  }) async {
    await _instance.zonedSchedule(
      0,
      title,
      body,
      scheduledDate ?? getDrawSchedule(),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static cancelNotification() {
    _instance.cancelAll();
  }

  static tz.TZDateTime getDrawSchedule() {
    var drawDate = AppConstants().getNextDrawDateTime();
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, drawDate.year, drawDate.month, drawDate.day, 21, 00);
    if (scheduledDate.isBefore(drawDate)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    print(scheduledDate);

    return scheduledDate;
  }
}
