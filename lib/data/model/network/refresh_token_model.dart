import 'dart:convert';

RefreshTokenModel refreshTokenModelFromJson(String str) => RefreshTokenModel.fromJson(json.decode(str));

String refreshTokenModelToJson(RefreshTokenModel data) => json.encode(data.toJson());

class RefreshTokenModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  RefreshTokenModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) => RefreshTokenModel(
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
  final String? accessToken;
  final DateTime? expiresAt;
  final DateTime? refreshExpiresAt;
  final String? refreshToken;
  final dynamic roles;
  final String? userEmail;
  final String? userId;
  final String? userName;
  final int? userType;
  final dynamic vendors;

  Data({
    this.accessToken,
    this.expiresAt,
    this.refreshExpiresAt,
    this.refreshToken,
    this.roles,
    this.userEmail,
    this.userId,
    this.userName,
    this.userType,
    this.vendors,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
        expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
        refreshExpiresAt: json["refresh_expires_at"] == null ? null : DateTime.parse(json["refresh_expires_at"]),
        refreshToken: json["refresh_token"],
        roles: json["roles"],
        userEmail: json["user_email"],
        userId: json["user_id"],
        userName: json["user_name"],
        userType: json["user_type"],
        vendors: json["vendors"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_at": expiresAt?.toIso8601String(),
        "refresh_expires_at": refreshExpiresAt?.toIso8601String(),
        "refresh_token": refreshToken,
        "roles": roles,
        "user_email": userEmail,
        "user_id": userId,
        "user_name": userName,
        "user_type": userType,
        "vendors": vendors,
      };
}
