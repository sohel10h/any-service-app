import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  ServiceModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": data?.toJson(),
      };
}

class Data {
  final MetaModel? meta;
  final List<ServiceData>? services;

  Data({
    this.meta,
    this.services,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        services: json["services"] == null ? [] : List<ServiceData>.from(json["services"]!.map((x) => ServiceData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class ServiceData {
  final String? id;
  final String? name;
  final num? price;
  final List<Category>? categories;
  final String? description;
  final String? createdBy;
  final String? updatedBy;
  final bool? priceRange;
  final num? priceStart;
  final num? priceEnd;

  ServiceData({
    this.id,
    this.name,
    this.price,
    this.categories,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.priceRange,
    this.priceStart,
    this.priceEnd,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
        id: json["id"],
        name: json["name"],
        price: json["price"]?.toDouble(),
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        description: json["description"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        priceRange: json["price_range"],
        priceStart: json["price_start"],
        priceEnd: json["price_end"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "description": description,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "price_range": priceRange,
        "price_start": priceStart,
        "price_end": priceEnd,
      };
}

class Category {
  final String? id;
  final String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
