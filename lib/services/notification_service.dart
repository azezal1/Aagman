import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> showBusArrivalNotification(String busName, int minutes) async {
    const androidDetails = AndroidNotificationDetails(
      'bus_arrival',
      'Bus Arrival',
      channelDescription: 'Notifications for bus arrivals',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      'Bus Arriving Soon! 🚌',
      '$busName is arriving in $minutes minutes',
      details,
    );
  }

  Future<void> showDelayNotification(String busName, int delayMinutes) async {
    const androidDetails = AndroidNotificationDetails(
      'bus_delay',
      'Bus Delays',
      channelDescription: 'Notifications for bus delays',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      1,
      'Bus Delayed ⏰',
      '$busName is delayed by $delayMinutes minutes',
      details,
    );
  }

  Future<void> showBoardingReminder(String busName, String stopName) async {
    const androidDetails = AndroidNotificationDetails(
      'boarding_reminder',
      'Boarding Reminders',
      channelDescription: 'Reminders to board your bus',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      2,
      'Time to Board! 🎫',
      '$busName is at $stopName. Don\'t miss it!',
      details,
    );
  }
}
