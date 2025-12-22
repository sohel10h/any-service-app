import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';
import 'package:service_la/data/model/network/common/service_model.dart';

BestSellingServiceCategoryModel bestSellingServiceCategoryModelFromJson(String str) =>
    BestSellingServiceCategoryModel.fromJson(json.decode(str));

String bestSellingServiceCategoryModelToJson(BestSellingServiceCategoryModel data) => json.encode(data.toJson());

class BestSellingServiceCategoryModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final BestSellingServiceCategory? bestSellingServiceCategory;

  BestSellingServiceCategoryModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.bestSellingServiceCategory,
  });

  factory BestSellingServiceCategoryModel.fromJson(Map<String, dynamic> json) => BestSellingServiceCategoryModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        bestSellingServiceCategory: json["data"] == null ? null : BestSellingServiceCategory.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": bestSellingServiceCategory?.toJson(),
      };
}

class BestSellingServiceCategory {
  final MetaModel? meta;
  final List<ServiceModel>? services;

  BestSellingServiceCategory({
    this.meta,
    this.services,
  });

  factory BestSellingServiceCategory.fromJson(Map<String, dynamic> json) => BestSellingServiceCategory(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        services: json["services"] == null ? [] : List<ServiceModel>.from(json["services"]!.map((x) => ServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}
