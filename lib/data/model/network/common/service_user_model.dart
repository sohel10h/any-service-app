class ServiceUserModel {
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
  final String? virtualPath;
  final int? rating;

  ServiceUserModel({
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
    this.virtualPath,
    this.rating,
  });

  factory ServiceUserModel.fromJson(Map<String, dynamic> json) => ServiceUserModel(
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
        virtualPath: json["virtual_path"],
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
        "virtual_path": virtualPath,
        "rating": rating,
      };
}
