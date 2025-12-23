import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';
import 'package:service_la/data/model/network/common/service_model.dart';

CategoryServiceModel categoryServiceModelFromJson(String str) => CategoryServiceModel.fromJson(json.decode(str));

String categoryServiceModelToJson(CategoryServiceModel data) => json.encode(data.toJson());

class CategoryServiceModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final CategoryService? categoryService;

  CategoryServiceModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.categoryService,
  });

  factory CategoryServiceModel.fromJson(Map<String, dynamic> json) => CategoryServiceModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        categoryService: json["data"] == null ? null : CategoryService.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": categoryService?.toJson(),
      };
}

class CategoryService {
  final MetaModel? meta;
  final List<ServiceModel>? services;

  CategoryService({
    this.meta,
    this.services,
  });

  factory CategoryService.fromJson(Map<String, dynamic> json) => CategoryService(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        services: json["services"] == null ? [] : List<ServiceModel>.from(json["services"]!.map((x) => ServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}
