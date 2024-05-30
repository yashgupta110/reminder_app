import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/main.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'reminder_channel_id', // channel ID
      'Reminder Notifications', // channel name
      channelDescription: 'Channel for Reminder notifications', // channel description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
