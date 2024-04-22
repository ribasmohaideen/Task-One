import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void displayNormalMessage(title, message) {
    var androiInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSetting = InitializationSettings(android: androiInit);
    _notificationsPlugin.initialize(initSetting);
    var androidDetails =
        const AndroidNotificationDetails("channelName", "channel Description");
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);
    _notificationsPlugin.show(1, title, message, generalNotificationDetails);
  }
}
