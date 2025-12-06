import 'dart:convert';
import 'package:service_la/data/model/network/common/category_model.dart';

ServiceCategoryResponseModel serviceCategoryResponseModelFromJson(String str) => ServiceCategoryResponseModel.fromJson(json.decode(str));

String serviceCategoryResponseModelToJson(ServiceCategoryResponseModel data) => json.encode(data.toJson());

class ServiceCategoryResponseModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final List<CategoryModel>? categories;

  ServiceCategoryResponseModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.categories,
  });

  factory ServiceCategoryResponseModel.fromJson(Map<String, dynamic> json) => ServiceCategoryResponseModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        categories: json["data"] == null ? [] : List<CategoryModel>.from(json["data"]!.map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}
