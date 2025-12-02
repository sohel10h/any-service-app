import 'dart:convert';
import 'package:service_la/data/model/network/common/picture_model.dart';

AdminUserModel adminUserModelFromJson(String str) => AdminUserModel.fromJson(json.decode(str));

String adminUserModelToJson(AdminUserModel data) => json.encode(data.toJson());

class AdminUserModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final AdminUser? adminUser;

  AdminUserModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.adminUser,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) => AdminUserModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        adminUser: json["data"] == null ? null : AdminUser.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": adminUser?.toJson(),
      };
}

class AdminUser {
  final String? id;
  final String? name;
  final String? email;
  final String? mobile;
  final int? userType;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final bool? isActive;
  final bool? isDelete;
  final int? serviceCompletedCount;
  final int? totalReview;
  final String? pictureId;
  final PictureModel? picture;
  final num? rating;

  AdminUser({
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
    this.serviceCompletedCount,
    this.totalReview,
    this.pictureId,
    this.picture,
    this.rating,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        userType: json["user_type"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isActive: json["is_active"],
        isDelete: json["is_delete"],
        serviceCompletedCount: json["service_completed_count"],
        totalReview: json["total_review"],
        pictureId: json["picture_id"],
        picture: json["picture"] == null ? null : PictureModel.fromJson(json["picture"]),
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "user_type": userType,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_active": isActive,
        "is_delete": isDelete,
        "service_completed_count": serviceCompletedCount,
        "total_review": totalReview,
        "picture_id": pictureId,
        "picture": picture?.toJson(),
        "rating": rating,
      };
}
