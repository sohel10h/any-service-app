import 'dart:convert';
import 'package:service_la/data/model/network/common/review_model.dart';
import 'package:service_la/data/model/network/common/picture_model.dart';
import 'package:service_la/data/model/network/common/service_user_model.dart';

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
  final num? price;
  final int? serviceCompletedCount;
  final int? rating;
  final int? totalReview;
  final List<CreateServiceDetailsCategory>? categories;
  final String? description;
  final String? createdBy;
  final String? updatedBy;
  final bool? priceRange;
  final num? priceStart;
  final num? priceEnd;
  final String? createdAt;
  final String? updatedAt;
  final List<PictureModel>? pictures;
  final List<CreateServiceDetailsReview>? reviews;
  final ServiceUserModel? user;

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
    this.reviews,
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
        pictures: json["pictures"] == null ? [] : List<PictureModel>.from(json["pictures"]!.map((x) => PictureModel.fromJson(x))),
        reviews: json["review"] == null
            ? []
            : List<CreateServiceDetailsReview>.from(json["review"]!.map((x) => CreateServiceDetailsReview.fromJson(x))),
        user: json["user"] == null ? null : ServiceUserModel.fromJson(json["user"]),
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
        "review": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
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

class CreateServiceDetailsReview {
  final ReviewModel? review;
  final ServiceUserModel? user;
  final PictureModel? picture;

  CreateServiceDetailsReview({
    this.review,
    this.user,
    this.picture,
  });

  factory CreateServiceDetailsReview.fromJson(Map<String, dynamic> json) => CreateServiceDetailsReview(
        review: json["review"] == null ? null : ReviewModel.fromJson(json["review"]),
        user: json["user"] == null ? null : ServiceUserModel.fromJson(json["user"]),
        picture: json["picture"] == null ? null : PictureModel.fromJson(json["picture"]),
      );

  Map<String, dynamic> toJson() => {
        "review": review?.toJson(),
        "user": user?.toJson(),
        "picture": picture?.toJson(),
      };
}
