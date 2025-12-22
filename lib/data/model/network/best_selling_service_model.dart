import 'dart:convert';
import 'package:service_la/data/model/network/common/service_model.dart';

BestSellingServiceModel bestSellingServiceModelFromJson(String str) => BestSellingServiceModel.fromJson(json.decode(str));

String bestSellingServiceModelToJson(BestSellingServiceModel data) => json.encode(data.toJson());

class BestSellingServiceModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final List<ServiceModel>? bestSellingServices;

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
        bestSellingServices: json["data"] == null ? [] : List<ServiceModel>.from(json["data"]!.map((x) => ServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": bestSellingServices == null ? [] : List<dynamic>.from(bestSellingServices!.map((x) => x.toJson())),
      };
}
