import 'dart:convert';

SignUpModel signUpModelFromJson(String str) => SignUpModel.fromJson(json.decode(str));

String signUpModelToJson(SignUpModel data) => json.encode(data.toJson());

class SignUpModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  SignUpModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
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
  final String? name;
  final String? email;
  final String? mobile;
  final int? userType;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final bool? isDelete;

  Data({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.userType,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isDelete,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        userType: json["user_type"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        isActive: json["is_active"],
        isDelete: json["is_delete"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "user_type": userType,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_active": isActive,
        "is_delete": isDelete,
      };
}
