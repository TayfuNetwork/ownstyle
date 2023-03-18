import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sms/flutter_sms.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        var list = response.payload?.split(",");
        var mesaj = list![0];
        var numara = list[1];
        bool _result = await launchSms(message: mesaj, number: numara);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max, priority: Priority.high);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _notificationsPlugin.show(
        0, 'New Notification', 'Hello, World!', platformChannelSpecifics,
        payload: 'Custom_Sound');
  }

  randevuZamanla(String mesaj, String numara, int zaman) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final scheduledNotificationDateTime =
        DateTime.now().add(Duration(minutes: zaman));
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'Scheduled Notification',
        importance: Importance.max, priority: Priority.high);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        payload: "$mesaj,$numara",
        0,
        'Scheduled Notification',
        'This is a scheduled notification!',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
  
}

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  var list = response.payload?.split(",");
  var mesaj = list?[0] ?? "payload gelmedi";
  var numara = list?[1] ?? "05395904016";
  Future.delayed(Duration(seconds: 3), () async {
    bool _result = await launchSms(message: mesaj, number: numara);
  });
}
