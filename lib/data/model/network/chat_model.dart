import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final ChatData? chatData;

  ChatModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.chatData,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        chatData: json["data"] == null ? null : ChatData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": chatData?.toJson(),
      };
}

class ChatData {
  final MetaModel? meta;
  final List<Conversation>? conversations;

  ChatData({
    this.meta,
    this.conversations,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        conversations: json["conversations"] == null
            ? []
            : List<Conversation>.from(
                json["conversations"]!.map(
                  (x) => Conversation.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "conversations": conversations == null ? [] : List<dynamic>.from(conversations!.map((x) => x.toJson())),
      };
}

class Conversation {
  final String? id;
  final int? type;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final List<Participant>? participants;
  final LastMessage? lastMessage;
  bool? pinned;
  bool? archived;

  Conversation({
    this.id,
    this.type,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.participants,
    this.lastMessage,
    this.pinned,
    this.archived,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"],
        type: json["type"],
        createdBy: json["created_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        participants: json["participants"] == null ? [] : List<Participant>.from(json["participants"]!.map((x) => Participant.fromJson(x))),
        lastMessage: json["last_message"] == null ? null : LastMessage.fromJson(json["last_message"]),
        pinned: json["pinned"],
        archived: json["archived"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "participants": participants == null ? [] : List<dynamic>.from(participants!.map((x) => x.toJson())),
        "last_message": lastMessage?.toJson(),
        "pinned": pinned,
        "archived": archived,
      };
}

class LastMessage {
  final String? id;
  final String? conversationId;
  final String? senderId;
  final String? senderName;
  final String? content;
  final String? createdAt;
  final bool? isRead;

  LastMessage({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderName,
    this.content,
    this.createdAt,
    this.isRead,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        conversationId: json["conversation_id"],
        senderId: json["sender_id"],
        senderName: json["sender_name"],
        content: json["content"],
        createdAt: json["created_at"],
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "sender_id": senderId,
        "sender_name": senderName,
        "content": content,
        "created_at": createdAt,
        "is_read": isRead,
      };
}

class Participant {
  final String? userId;
  final String? userName;
  final String? pictureUrl;

  Participant({
    this.userId,
    this.userName,
    this.pictureUrl,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        userId: json["user_id"],
        userName: json["user_name"],
        pictureUrl: json["picture_url"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "picture_url": pictureUrl,
      };
}
