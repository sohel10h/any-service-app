import 'dart:convert';

SignInModel signInModelFromJson(String str) => SignInModel.fromJson(json.decode(str));

String signInModelToJson(SignInModel data) => json.encode(data.toJson());

class SignInModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  SignInModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory SignInModel.fromJson(Map<String, dynamic> json) => SignInModel(
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

  Data({
    this.accessToken,
    this.expiresAt,
    this.refreshExpiresAt,
    this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
        expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
        refreshExpiresAt: json["refresh_expires_at"] == null ? null : DateTime.parse(json["refresh_expires_at"]),
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_at": expiresAt?.toIso8601String(),
        "refresh_expires_at": refreshExpiresAt?.toIso8601String(),
        "refresh_token": refreshToken,
      };
}
