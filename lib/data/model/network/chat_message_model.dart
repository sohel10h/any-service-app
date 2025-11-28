import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';

ChatMessageModel chatMessageModelFromJson(String str) => ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) => json.encode(data.toJson());

class ChatMessageModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final ChatMessageData? chatMessageData;

  ChatMessageModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.chatMessageData,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        chatMessageData: json["data"] == null ? null : ChatMessageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": chatMessageData?.toJson(),
      };
}

class ChatMessageData {
  final MetaModel? meta;
  final List<ChatMessage>? chatMessages;

  ChatMessageData({
    this.meta,
    this.chatMessages,
  });

  factory ChatMessageData.fromJson(Map<String, dynamic> json) => ChatMessageData(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        chatMessages: json["messages"] == null
            ? []
            : List<ChatMessage>.from(
                json["messages"]!.map(
                  (x) => ChatMessage.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "messages": chatMessages == null ? [] : List<dynamic>.from(chatMessages!.map((x) => x.toJson())),
      };
}

class ChatMessage {
  final String? id;
  final String? conversationId;
  final String? senderId;
  final String? senderName;
  final String? content;
  final String? createdAt;

  ChatMessage({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderName,
    this.content,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        conversationId: json["conversation_id"],
        senderId: json["sender_id"],
        senderName: json["sender_name"],
        content: json["content"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "sender_id": senderId,
        "sender_name": senderName,
        "content": content,
        "created_at": createdAt,
      };
}
