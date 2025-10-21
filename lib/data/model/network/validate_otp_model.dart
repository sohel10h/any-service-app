import 'dart:convert';

ValidateOtpModel validateOtpModelFromJson(String str) => ValidateOtpModel.fromJson(json.decode(str));

String validateOtpModelToJson(ValidateOtpModel data) => json.encode(data.toJson());

class ValidateOtpModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  ValidateOtpModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory ValidateOtpModel.fromJson(Map<String, dynamic> json) => ValidateOtpModel(
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
  final String? identifier;
  final String? identifierType;
  final String? otpCode;
  final bool? isVerified;
  final int? attempts;
  final String? sessionToken;
  final bool? consumed;
  final DateTime? expiresAt;
  final DateTime? verifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.identifier,
    this.identifierType,
    this.otpCode,
    this.isVerified,
    this.attempts,
    this.sessionToken,
    this.consumed,
    this.expiresAt,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        identifier: json["identifier"],
        identifierType: json["identifier_type"],
        otpCode: json["otp_code"],
        isVerified: json["is_verified"],
        attempts: json["attempts"],
        sessionToken: json["session_token"],
        consumed: json["consumed"],
        expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
        verifiedAt: json["verified_at"] == null ? null : DateTime.parse(json["verified_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "identifier_type": identifierType,
        "otp_code": otpCode,
        "is_verified": isVerified,
        "attempts": attempts,
        "session_token": sessionToken,
        "consumed": consumed,
        "expires_at": expiresAt?.toIso8601String(),
        "verified_at": verifiedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
