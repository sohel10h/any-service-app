import 'dart:convert';
import 'package:service_la/data/model/network/common/picture_model.dart';

BestSellingServiceModel bestSellingServiceModelFromJson(String str) => BestSellingServiceModel.fromJson(json.decode(str));

String bestSellingServiceModelToJson(BestSellingServiceModel data) => json.encode(data.toJson());

class BestSellingServiceModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final List<BestSellingServiceData>? bestSellingServices;

  BestSellingServiceModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.bestSellingServices,
  });

  factory BestSellingServiceModel.fromJson(Map<String, dynamic> json) => BestSellingServiceModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        bestSellingServices: json["data"] == null
            ? []
            : List<BestSellingServiceData>.from(
                json["data"]!.map(
                  (x) => BestSellingServiceData.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": bestSellingServices == null ? [] : List<dynamic>.from(bestSellingServices!.map((x) => x.toJson())),
      };
}

class BestSellingServiceData {
  final String? id;
  final String? name;
  final String? description;
  final num? price;
  final bool? priceRange;
  final num? priceStart;
  final num? priceEnd;
  final int? rating;
  final int? serviceCompletedCount;
  final int? totalReview;
  final PictureModel? picture;

  BestSellingServiceData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.priceRange,
    this.priceStart,
    this.priceEnd,
    this.rating,
    this.serviceCompletedCount,
    this.totalReview,
    this.picture,
  });

  factory BestSellingServiceData.fromJson(Map<String, dynamic> json) => BestSellingServiceData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        priceRange: json["price_range"],
        priceStart: json["price_start"]?.toDouble(),
        priceEnd: json["price_end"]?.toDouble(),
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
        "rating": rating,
        "service_completed_count": serviceCompletedCount,
        "total_review": totalReview,
        "picture": picture?.toJson(),
      };
}
