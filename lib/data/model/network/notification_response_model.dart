import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';
import 'package:service_la/data/model/network/common/notification_model.dart';

NotificationResponseModel notificationResponseModelFromJson(String str) => NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) => json.encode(data.toJson());

class NotificationResponseModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final NotificationData? notificationData;

  NotificationResponseModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.notificationData,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => NotificationResponseModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        notificationData: json["data"] == null ? null : NotificationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": notificationData?.toJson(),
      };
}

class NotificationData {
  final MetaModel? meta;
  final List<NotificationModel>? notifications;

  NotificationData({
    this.meta,
    this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        notifications: json["notifications"] == null
            ? []
            : List<NotificationModel>.from(json["notifications"]!.map((x) => NotificationModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
      };
}
