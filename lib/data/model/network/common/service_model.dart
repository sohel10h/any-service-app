import 'package:service_la/data/model/network/common/category_model.dart';
import 'package:service_la/data/model/network/common/picture_model.dart';

class ServiceModel {
  final String? id;
  final String? name;
  final String? description;
  final int? price;
  final bool? priceRange;
  final double? priceStart;
  final double? priceEnd;
  final List<CategoryModel>? categories;
  final int? rating;
  final int? serviceCompletedCount;
  final int? totalReview;
  final PictureModel? picture;

  ServiceModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.priceRange,
    this.priceStart,
    this.priceEnd,
    this.categories,
    this.rating,
    this.serviceCompletedCount,
    this.totalReview,
    this.picture,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        priceRange: json["price_range"],
        priceStart: json["price_start"]?.toDouble(),
        priceEnd: json["price_end"]?.toDouble(),
        categories: json["categories"] == null ? [] : List<CategoryModel>.from(json["categories"]!.map((x) => CategoryModel.fromJson(x))),
        rating: json["rating"],
        serviceCompletedCount: json["service_completed_count"],
        totalReview: json["total_review"],
        picture: json["picture"] == null ? null : PictureModel.fromJson(json["picture"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "price_range": priceRange,
        "price_start": priceStart,
        "price_end": priceEnd,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "rating": rating,
        "service_completed_count": serviceCompletedCount,
        "total_review": totalReview,
        "picture": picture?.toJson(),
      };
}
