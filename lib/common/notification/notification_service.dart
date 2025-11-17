import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const String channelId = "servicela_app_notification_id";
const String channelName = "servicela_app_notification_channel";
const String channelDescription = "servicela app push notification";

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

class NotificationService {
  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/launcher_icon");
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentSound: true,
      defaultPresentBadge: true,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log("click onDidReceiveNotificationResponse: $details");
      },
    );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('default'),
    );
    final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestNotificationPermissionFirstTime();
    //await subscribeToTopic("all_users");
  }

  static Future<void> _requestNotificationPermissionFirstTime() async {
    bool? isAsked = StorageHelper.getValue(StorageHelper.notificationPermissionAsked) ?? false;
    if (isAsked != true) {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      log("Notification permission status: ${settings.authorizationStatus}");
      StorageHelper.setValue(StorageHelper.notificationPermissionAsked, true);
    }
  }
}

Future<void> subscribeToTopic(String topic) async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.subscribeToTopic(topic);
    log("Subscribed to topic: $topic");
  } catch (e) {
    log("Error subscribing to topic $topic: $e");
  }
}

Future showSimpleNotification({required String title, required String body, required String payload}) async {
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.max,
    priority: Priority.high,
    ticker: "ticker",
    playSound: true,
    styleInformation: BigTextStyleInformation(""),
  );
  DarwinNotificationDetails iOSNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    subtitle: body,
    sound: "default",
  );

  NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iOSNotificationDetails);
  await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
}
