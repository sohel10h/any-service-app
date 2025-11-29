import 'dart:convert';

class WebsocketNotificationModel {
  final String title;
  final String rawData;
  final String? data;
  final String? id;
  final int? type;
  final String? userId;
  final String? body;
  final String? pictureUrl;
  final int? unreadCount;

  WebsocketNotificationModel({
    required this.title,
    required this.rawData,
    this.data,
    this.id,
    this.type,
    this.userId,
    this.body,
    this.pictureUrl,
    this.unreadCount,
  });

  factory WebsocketNotificationModel.fromMap(Map<String, dynamic> m) {
    final title = (m['title'] ?? '').toString();
    final dynamic dataField = m['data'];

    String rawData = '';
    Map<String, dynamic> parsed = {};

    if (dataField is String) {
      rawData = dataField;
      try {
        parsed = jsonDecode(dataField) as Map<String, dynamic>;
      } catch (_) {}
    } else if (dataField is Map) {
      parsed = Map<String, dynamic>.from(dataField);
      rawData = jsonEncode(parsed);
    }

    return WebsocketNotificationModel(
      title: title,
      rawData: rawData,
      data: parsed['Data']?.toString(),
      id: parsed['ID']?.toString(),
      type: parsed['Type'] is int ? parsed['Type'] : int.tryParse(parsed['Type']?.toString() ?? ''),
      userId: parsed['UserID']?.toString(),
      body: m['body']?.toString(),
      pictureUrl: m['picture_url']?.toString(),
      unreadCount: m['unread_count'] is int ? m['unread_count'] : int.tryParse(m['unread_count']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'rawData': rawData,
        'data': data,
        'id': id,
        'type': type,
        'userId': userId,
        'body': body,
        'pictureUrl': pictureUrl,
        'unreadCount': unreadCount,
      };
}
