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
            : List<ServiceRequestMe>.from(
                json["service_requests"]!.map((x) => ServiceRequestMe.fromJson(x)),
              ),
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
  final String? serviceRequestCreatedOn;
  final CreatedBy? createdBy;
  final num? budgetMin;
  final num? budgetMax;
  final CreatedBy? vendor;
  final Picture? picture;

  ServiceRequestMe({
    this.id,
    this.title,
    this.status,
    this.serviceRequestCreatedOn,
    this.createdBy,
    this.budgetMin,
    this.budgetMax,
    this.vendor,
    this.picture,
  });

  factory ServiceRequestMe.fromJson(Map<String, dynamic> json) => ServiceRequestMe(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        serviceRequestCreatedOn: json["service_request_created_on"],
        createdBy: json["created_by"] == null ? null : CreatedBy.fromJson(json["created_by"]),
        budgetMin: json["budget_min"]?.toDouble(),
        budgetMax: json["budget_max"]?.toDouble(),
        vendor: json["vendor"] == null ? null : CreatedBy.fromJson(json["vendor"]),
        picture: json["picture"] == null ? null : Picture.fromJson(json["picture"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "service_request_created_on": serviceRequestCreatedOn,
        "created_by": createdBy?.toJson(),
        "budget_min": budgetMin,
        "budget_max": budgetMax,
        "vendor": vendor?.toJson(),
        "picture": picture?.toJson(),
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

class Picture {
  final String? virtualPath;

  Picture({
    this.virtualPath,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        virtualPath: json["virtual_path"],
      );

  Map<String, dynamic> toJson() => {
        "virtual_path": virtualPath,
      };
}
