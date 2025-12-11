import 'dart:convert';

WebsocketNotificationReadModel websocketNotificationReadModelFromJson(String str) =>
    WebsocketNotificationReadModel.fromMap(json.decode(str));

String websocketNotificationReadModelToJson(WebsocketNotificationReadModel data) => json.encode(data.toJson());

class WebsocketNotificationReadModel {
  final String? type;
  final String? notificationId;
  final int? unreadCount;

  WebsocketNotificationReadModel({
    this.type,
    this.notificationId,
    this.unreadCount,
  });

  factory WebsocketNotificationReadModel.fromMap(Map<String, dynamic> json) => WebsocketNotificationReadModel(
        type: json["type"],
        notificationId: json["notification_id"],
        unreadCount: json["unread_count"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "notification_id": notificationId,
        "unread_count": unreadCount,
      };
}
