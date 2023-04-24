import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) async {
      var list = response.payload?.split(",");
      var mesaj = list![0];
      var numara = list[1];
    }, );
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

  randevuZamanla(String numara, DateTime zaman) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final DateTime date = zaman;
    final scheduledNotificationDateTime =
        date.subtract(const Duration(minutes: 20));
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'Scheduled Notification',
        importance: Importance.max, priority: Priority.high);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    int notificationId = DateTime.now()
        .millisecondsSinceEpoch
        .remainder(100000); // random id oluşturuluyor

    await flutterLocalNotificationsPlugin.schedule(
        payload: "$numara",
        notificationId,
        'Sıradaki Randevunuz - $numara',
        'Sıradaki müşterinize randevusunu hatırlatın!',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notoficationResponse) async {
  var list = notoficationResponse.payload?.split(",");
  var mesaj = list?[0] ?? "payload gelmedi";
  var numara = list?[1] ?? "05395904016";
}
