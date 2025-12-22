import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';
import 'package:service_la/data/model/network/common/category_model.dart';

AllServiceCategoryResponseModel allServiceCategoryResponseModelFromJson(String str) =>
    AllServiceCategoryResponseModel.fromJson(json.decode(str));

String allServiceCategoryResponseModelToJson(AllServiceCategoryResponseModel data) => json.encode(data.toJson());

class AllServiceCategoryResponseModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final ServiceCategory? serviceCategory;

  AllServiceCategoryResponseModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.serviceCategory,
  });

  factory AllServiceCategoryResponseModel.fromJson(Map<String, dynamic> json) => AllServiceCategoryResponseModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        serviceCategory: json["data"] == null ? null : ServiceCategory.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": serviceCategory?.toJson(),
      };
}

class ServiceCategory {
  final MetaModel? meta;
  final List<CategoryModel>? categories;

  ServiceCategory({
    this.meta,
    this.categories,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) => ServiceCategory(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        categories: json["categories"] == null ? [] : List<CategoryModel>.from(json["categories"]!.map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}
