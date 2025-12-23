import 'dart:convert';
import 'package:service_la/data/model/network/common/service_model.dart';
import 'package:service_la/data/model/network/common/category_model.dart';

CategoryBestSellerServiceModel categoryBestSellerServiceModelFromJson(String str) =>
    CategoryBestSellerServiceModel.fromJson(json.decode(str));

String categoryBestSellerServiceModelToJson(CategoryBestSellerServiceModel data) => json.encode(data.toJson());

class CategoryBestSellerServiceModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final List<ServiceModel>? services;

  CategoryBestSellerServiceModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.services,
  });

  factory CategoryBestSellerServiceModel.fromJson(Map<String, dynamic> json) => CategoryBestSellerServiceModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        services: json["data"] == null ? [] : List<ServiceModel>.from(json["data"]!.map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}
