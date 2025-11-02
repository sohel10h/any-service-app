import 'dart:convert';

UserDeviceTokenModel userDeviceTokenModelFromJson(String str) => UserDeviceTokenModel.fromJson(json.decode(str));

String userDeviceTokenModelToJson(UserDeviceTokenModel data) => json.encode(data.toJson());

class UserDeviceTokenModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  UserDeviceTokenModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory UserDeviceTokenModel.fromJson(Map<String, dynamic> json) => UserDeviceTokenModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": data?.toJson(),
      };
}

class Data {
  final String? id;
  final String? userId;
  final String? deviceToken;
  final int? deviceType;
  final DateTime? createdOnUtc;
  final DateTime? updatedOnUtc;

  Data({
    this.id,
    this.userId,
    this.deviceToken,
    this.deviceType,
    this.createdOnUtc,
    this.updatedOnUtc,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        deviceToken: json["device_token"],
        deviceType: json["device_type"],
        createdOnUtc: json["created_on_utc"] == null ? null : DateTime.parse(json["created_on_utc"]),
        updatedOnUtc: json["updated_on_utc"] == null ? null : DateTime.parse(json["updated_on_utc"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "device_token": deviceToken,
        "device_type": deviceType,
        "created_on_utc": createdOnUtc?.toIso8601String(),
        "updated_on_utc": updatedOnUtc?.toIso8601String(),
      };
}
