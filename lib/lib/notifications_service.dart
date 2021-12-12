import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  // Кроссплатформенный API, предоставляет абстракцию для всех платформ. Таким образом, конфигурация платформы передается как данные.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initState() async {

    // Класс для инициализации настроек для устройств Android
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    // Класс для инициализации настроек для устройств ios
    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    // Инициализировать настройки для платформ android и ios
    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);


    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Метод для обработки нажатия на уведомление
  Future selectNotification(String? payload) async {

  }

  Future<void> showNotification(int id, String title, String body, int seconds) async {
    tz.TZDateTime timeNotification = tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      timeNotification,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          icon: 'app_icon',
          channelDescription: 'Main channel notifications',
          importance: Importance.max,
          priority: Priority.max,
        ),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}