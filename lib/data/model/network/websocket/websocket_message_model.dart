import 'package:service_la/data/model/network/common/chat_message_model.dart';

class WebsocketMessageModel {
  final String? type;
  final ChatMessageModel? message;
  final String? conversationId;
  final String? userId;

  WebsocketMessageModel({
    this.type,
    this.message,
    this.conversationId,
    this.userId,
  });

  factory WebsocketMessageModel.fromMap(Map<String, dynamic> json) {
    return WebsocketMessageModel(
      type: json['type']?.toString() ?? '',
      message: json["message"] == null ? null : ChatMessageModel.fromJson(json["message"]),
      conversationId: json['conversation_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'message': message?.toJson(),
      'conversation_id': conversationId,
      'user_id': userId,
    };
  }
}
