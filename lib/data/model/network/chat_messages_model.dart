import 'dart:convert';
import 'package:service_la/data/model/network/common/chat_message_model.dart';
import 'package:service_la/data/model/network/common/meta_model.dart';

ChatMessagesModel chatMessagesModelFromJson(String str) => ChatMessagesModel.fromJson(json.decode(str));

String chatMessagesModelToJson(ChatMessagesModel data) => json.encode(data.toJson());

class ChatMessagesModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final ChatMessageData? chatMessageData;

  ChatMessagesModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.chatMessageData,
  });

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) => ChatMessagesModel(
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
  final List<ChatMessageModel>? chatMessages;

  ChatMessageData({
    this.meta,
    this.chatMessages,
  });

  factory ChatMessageData.fromJson(Map<String, dynamic> json) => ChatMessageData(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        chatMessages: json["messages"] == null
            ? []
            : List<ChatMessageModel>.from(
                json["messages"]!.map(
                  (x) => ChatMessageModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "messages": chatMessages == null ? [] : List<dynamic>.from(chatMessages!.map((x) => x.toJson())),
      };
}
