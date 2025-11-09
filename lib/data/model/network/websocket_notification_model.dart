import 'dart:convert';

class WebsocketNotificationModel {
  final String title;
  final String rawData;
  final String? message;
  final String? id;
  final int? type;
  final String? userId;

  WebsocketNotificationModel({
    required this.title,
    required this.rawData,
    this.message,
    this.id,
    this.type,
    this.userId,
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
      message: parsed['Data']?.toString(),
      id: parsed['ID']?.toString(),
      type: parsed['Type'] is int ? parsed['Type'] : int.tryParse(parsed['Type']?.toString() ?? ''),
      userId: parsed['UserID']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'rawData': rawData,
        'message': message,
        'id': id,
        'type': type,
        'userId': userId,
      };
}
