import 'dart:convert';

CreateServiceDetailsModel createServiceDetailsModelFromJson(String str) => CreateServiceDetailsModel.fromJson(json.decode(str));

String createServiceDetailsModelToJson(CreateServiceDetailsModel data) => json.encode(data.toJson());

class CreateServiceDetailsModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final CreateServiceDetailsData? createServiceDetailsData;

  CreateServiceDetailsModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.createServiceDetailsData,
  });

  factory CreateServiceDetailsModel.fromJson(Map<String, dynamic> json) => CreateServiceDetailsModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        createServiceDetailsData: json["data"] == null ? null : CreateServiceDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": createServiceDetailsData?.toJson(),
      };
}

class CreateServiceDetailsData {
  final String? id;
  final String? name;
  final double? price;
  final int? serviceCompletedCount;
  final int? rating;
  final int? totalReview;
  final List<CreateServiceDetailsCategory>? categories;
  final String? description;
  final String? createdBy;
  final String? updatedBy;
  final bool? priceRange;
  final int? priceStart;
  final int? priceEnd;
  final String? createdAt;
  final String? updatedAt;
  final List<CreateServiceDetailsPicture>? pictures;
  final List<dynamic>? review;
  final User? user;

  CreateServiceDetailsData({
    this.id,
    this.name,
    this.price,
    this.serviceCompletedCount,
    this.rating,
    this.totalReview,
    this.categories,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.priceRange,
    this.priceStart,
    this.priceEnd,
    this.createdAt,
    this.updatedAt,
    this.pictures,
    this.review,
    this.user,
  });

  factory CreateServiceDetailsData.fromJson(Map<String, dynamic> json) => CreateServiceDetailsData(
        id: json["id"],
        name: json["name"],
        price: json["price"]?.toDouble(),
        serviceCompletedCount: json["service_completed_count"],
        rating: json["rating"],
        totalReview: json["total_review"],
        categories: json["categories"] == null
            ? []
            : List<CreateServiceDetailsCategory>.from(json["categories"]!.map((x) => CreateServiceDetailsCategory.fromJson(x))),
        description: json["description"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        priceRange: json["price_range"],
        priceStart: json["price_start"],
        priceEnd: json["price_end"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pictures: json["pictures"] == null
            ? []
            : List<CreateServiceDetailsPicture>.from(json["pictures"]!.map((x) => CreateServiceDetailsPicture.fromJson(x))),
        review: json["review"] == null ? [] : List<dynamic>.from(json["review"]!.map((x) => x)),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "service_completed_count": serviceCompletedCount,
        "rating": rating,
        "total_review": totalReview,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "description": description,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "price_range": priceRange,
        "price_start": priceStart,
        "price_end": priceEnd,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pictures": pictures == null ? [] : List<dynamic>.from(pictures!.map((x) => x.toJson())),
        "review": review == null ? [] : List<dynamic>.from(review!.map((x) => x)),
        "user": user?.toJson(),
      };
}

class CreateServiceDetailsCategory {
  final String? id;
  final String? name;

  CreateServiceDetailsCategory({
    this.id,
    this.name,
  });

  factory CreateServiceDetailsCategory.fromJson(Map<String, dynamic> json) => CreateServiceDetailsCategory(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class CreateServiceDetailsPicture {
  final String? id;
  final String? mimeType;
  final String? seoFilename;
  final String? altAttribute;
  final String? titleAttribute;
  final String? virtualPath;
  final int? displayOrder;
  final bool? isIcon;

  CreateServiceDetailsPicture({
    this.id,
    this.mimeType,
    this.seoFilename,
    this.altAttribute,
    this.titleAttribute,
    this.virtualPath,
    this.displayOrder,
    this.isIcon,
  });

  factory CreateServiceDetailsPicture.fromJson(Map<String, dynamic> json) => CreateServiceDetailsPicture(
        id: json["id"],
        mimeType: json["mime_type"],
        seoFilename: json["seo_filename"],
        altAttribute: json["alt_attribute"],
        titleAttribute: json["title_attribute"],
        virtualPath: json["virtual_path"],
        displayOrder: json["display_order"],
        isIcon: json["is_icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mime_type": mimeType,
        "seo_filename": seoFilename,
        "alt_attribute": altAttribute,
        "title_attribute": titleAttribute,
        "virtual_path": virtualPath,
        "display_order": displayOrder,
        "is_icon": isIcon,
      };
}

class User {
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
  final dynamic pictureId;
  final int? rating;

  User({
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
    this.rating,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        "rating": rating,
      };
}
