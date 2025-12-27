class NotificationModel {
  final String? id;
  final String? title;
  final int? type;
  final String? typeId;
  final String? createdOnUtc;
  final String? body;
  final String? pictureUrl;
  bool? isRead;

  NotificationModel({
    this.id,
    this.title,
    this.type,
    this.typeId,
    this.createdOnUtc,
    this.body,
    this.pictureUrl,
    this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        typeId: json["type_id"],
        createdOnUtc: json["created_on_utc"],
        body: json["body"],
        pictureUrl: json["picture_url"],
        isRead: json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "type": type,
        "type_id": typeId,
        "created_on_utc": createdOnUtc,
        "body": body,
        "picture_url": pictureUrl,
        "is_read": isRead,
      };
}
