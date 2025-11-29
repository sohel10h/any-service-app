import 'dart:convert';

class WebsocketResponseModel<T> {
  final String? type; // top-level type
  final NotificationData<T>? notification;

  WebsocketResponseModel({
    this.type,
    this.notification,
  });

  factory WebsocketResponseModel.fromApiResponse(
    Map<String, dynamic> response,
    T Function(Map<String, dynamic>) parser,
  ) {
    final type = response['type'] as String?;
    final notificationMap = response['notification'] as Map<String, dynamic>?;

    return WebsocketResponseModel(
      type: type,
      notification: notificationMap != null ? NotificationData<T>.fromMap(notificationMap, parser) : null,
    );
  }
}

class NotificationData<T> {
  final String? title;
  final String? body;
  final int? type;
  final String? pictureUrl;
  final int? unreadCount;
  final T? parsedData;

  NotificationData({
    this.title,
    this.body,
    this.type,
    this.pictureUrl,
    this.unreadCount,
    this.parsedData,
  });

  factory NotificationData.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) parser,
  ) {
    final dataString = map['data'] as String?;
    final Map<String, dynamic>? decoded = dataString != null ? jsonDecode(dataString) : null;

    return NotificationData<T>(
      title: map['title'] as String?,
      body: map['body'] as String?,
      type: map['type'] as int?,
      pictureUrl: map['picture_url'] as String?,
      unreadCount: map['unread_count'] as int?,
      parsedData: decoded != null ? parser(decoded) : null,
    );
  }
}
