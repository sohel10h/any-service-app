import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';

ServiceRequestMeModel serviceRequestMeModelFromJson(String str) => ServiceRequestMeModel.fromJson(json.decode(str));

String serviceRequestMeModelToJson(ServiceRequestMeModel data) => json.encode(data.toJson());

class ServiceRequestMeModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final ServiceRequestMeData? serviceRequestMeData;

  ServiceRequestMeModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.serviceRequestMeData,
  });

  factory ServiceRequestMeModel.fromJson(Map<String, dynamic> json) => ServiceRequestMeModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        serviceRequestMeData: json["data"] == null ? null : ServiceRequestMeData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": serviceRequestMeData?.toJson(),
      };
}

class ServiceRequestMeData {
  final MetaModel? meta;
  final List<ServiceRequestMe>? serviceRequests;

  ServiceRequestMeData({
    this.meta,
    this.serviceRequests,
  });

  factory ServiceRequestMeData.fromJson(Map<String, dynamic> json) => ServiceRequestMeData(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        serviceRequests: json["service_requests"] == null
            ? []
            : List<ServiceRequestMe>.from(json["service_requests"]!.map((x) => ServiceRequestMe.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "service_requests": serviceRequests == null ? [] : List<dynamic>.from(serviceRequests!.map((x) => x.toJson())),
      };
}

class ServiceRequestMe {
  final String? id;
  final String? title;
  final int? status;
  final CreatedBy? createdBy;
  final num? budgetMin;
  final num? budgetMax;

  ServiceRequestMe({
    this.id,
    this.title,
    this.status,
    this.createdBy,
    this.budgetMin,
    this.budgetMax,
  });

  factory ServiceRequestMe.fromJson(Map<String, dynamic> json) => ServiceRequestMe(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
        budgetMin: json["budget_min"]?.toDouble(),
        budgetMax: json["budget_max"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "created_by": createdBy?.toJson(),
        "budget_min": budgetMin,
        "budget_max": budgetMax,
      };
}

class CreatedBy {
  final String? id;
  final String? name;

  CreatedBy({
    this.id,
    this.name,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
