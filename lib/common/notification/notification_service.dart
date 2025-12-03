import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:service_la/data/model/network/websocket/websocket_message_model.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const String channelId = "servicela_app_notification_id";
const String channelName = "servicela_app_notification_channel";
const String channelDescription = "servicela app push notification";

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  final payload = response.payload;
  if (payload != null && payload.isNotEmpty) {
    log("Background notification payload: $payload");
    Get.toNamed(
      AppRoutes.serviceRequestDetailsScreen,
      arguments: {"serviceRequestId": payload},
    );
  }
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
      enableVibration: true,
    );
    final androidPlugin = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestNotificationPermissionFirstTime();
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payloadStr = response.payload;
        log("Notification payload: $payloadStr");
        if (payloadStr != null) {
          final Map<String, dynamic> payload = jsonDecode(payloadStr);
          final websocketMessage = WebsocketMessageModel.fromMap(payload);
          if (websocketMessage.type == WebsocketPayloadType.message.name) {
            AppDIController.lastChatRoomUserId.value = websocketMessage.message?.senderId ?? "";
            _goToChatsRoomScreen(
              username: websocketMessage.message?.senderName ?? "",
              conversationId: websocketMessage.conversationId ?? "",
              userId: websocketMessage.message?.senderId ?? "",
            );
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    //await subscribeToTopic("all_users");
  }

  static void _goToChatsRoomScreen({
    required String username,
    required String conversationId,
    required String userId,
  }) {
    Get.toNamed(
      AppRoutes.chatsRoomScreen,
      arguments: {
        "chatUsername": username,
        "conversationId": conversationId,
        "chatUserId": userId,
        "isInsideChat": false,
      },
    );
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

  static Future<void> subscribeToTopic(String topic) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.subscribeToTopic(topic);
      log("Subscribed to topic: $topic");
    } catch (e) {
      log("Error subscribing to topic $topic: $e");
    }
  }

  static Future showSimpleNotification({required String title, required String body, required String payload}) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(""),
    );
    DarwinNotificationDetails iOSNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      subtitle: body,
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iOSNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
  }
}
