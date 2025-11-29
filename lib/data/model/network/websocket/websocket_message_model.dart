import 'package:service_la/data/model/network/chat_message_model.dart';

class WebsocketMessageModel {
  final String? type;
  final String? conversationId;
  final ChatMessage? message;

  WebsocketMessageModel({
    this.type,
    this.conversationId,
    this.message,
  });

  factory WebsocketMessageModel.fromMap(Map<String, dynamic> json) {
    return WebsocketMessageModel(
      type: json['type']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      message: json["message"] == null ? null : ChatMessage.fromJson(json["message"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'conversation_id': conversationId,
      'message': message?.toJson(),
    };
  }
}
