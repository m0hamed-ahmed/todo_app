import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {

  static Future<void> showNotification({required String title, required String body}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    InitializationSettings initializationSettings = const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) {});
    NotificationDetails notificationDetails = const NotificationDetails(android: AndroidNotificationDetails('channelId', 'channelName', priority: Priority.high, importance: Importance.max));
    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  static Future<void> showScheduleNotification({required int id, required String title, required String body, required DateTime dateTime}) async {
    tz.initializeTimeZones();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    InitializationSettings initializationSettings = const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (payload) {});
    NotificationDetails notificationDetails = const NotificationDetails(android: AndroidNotificationDetails('channelId', 'channelName', priority: Priority.high, importance: Importance.max));
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidAllowWhileIdle: true,
    );
  }

  static Future<void> cancelNotification({required int id}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}