class ChatMessageModel {
  final String? id;
  final String? conversationId;
  final String? senderId;
  final String? senderName;
  final String? content;
  final String? createdAt;
  final bool? isRead;
  bool? isLocal;
  bool? isFailed;

  ChatMessageModel({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderName,
    this.content,
    this.createdAt,
    this.isRead,
    this.isLocal,
    this.isFailed,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
        id: json["id"],
        conversationId: json["conversation_id"],
        senderId: json["sender_id"],
        senderName: json["sender_name"],
        content: json["content"],
        createdAt: json["created_at"],
        isRead: json["is_read"],
        isLocal: json["is_local"],
        isFailed: json["is_failed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "conversation_id": conversationId,
        "sender_id": senderId,
        "sender_name": senderName,
        "content": content,
        "created_at": createdAt,
        "is_read": isRead,
        "is_local": isLocal,
        "is_failed": isFailed,
      };
}
