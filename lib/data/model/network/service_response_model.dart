import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';
import 'package:service_la/data/model/network/common/service_model.dart';

ServiceResponseModel serviceResponseModelFromJson(String str) => ServiceResponseModel.fromJson(json.decode(str));

String serviceResponseModelToJson(ServiceResponseModel data) => json.encode(data.toJson());

class ServiceResponseModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  ServiceResponseModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory ServiceResponseModel.fromJson(Map<String, dynamic> json) => ServiceResponseModel(
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
  final List<ServiceModel>? services;

  Data({
    this.meta,
    this.services,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        services: json["services"] == null ? [] : List<ServiceModel>.from(json["services"]!.map((x) => ServiceModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}
