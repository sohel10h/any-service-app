import 'package:service_la/data/model/network/common/chat_message_model.dart';

class WebsocketMessageModel {
  final String? type;
  final String? conversationId;
  final ChatMessageModel? message;

  WebsocketMessageModel({
    this.type,
    this.conversationId,
    this.message,
  });

  factory WebsocketMessageModel.fromMap(Map<String, dynamic> json) {
    return WebsocketMessageModel(
      type: json['type']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      message: json["message"] == null ? null : ChatMessageModel.fromJson(json["message"]),
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
