import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String? TimeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(TimeZoneName!));
  }

  _initializeNotifications() async { // configurations of OSs
    const android = AndroidInitializationSettings('@mipmap/ic_launcher'); // get app icon
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android
      ),
      onDidReceiveNotificationResponse: (NotificationResponse noti) {
        print(noti.payload);
      }
    );
  }

  showNotification(CustomNotification notification, DateTime date) {
    androidDetails = const AndroidNotificationDetails(
        'remember_medine',
        'reminder',
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification')
    );
    localNotificationsPlugin.zonedSchedule(
      notification.id,notification.title,notification.body,
      tz.TZDateTime.from(date, tz.local),
      NotificationDetails(
        android: androidDetails
      ),
      payload: notification.payload,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  cancelNotification(int id) async {
    await localNotificationsPlugin.cancel(id);
  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      // print('closed open');
    }
  }
}
