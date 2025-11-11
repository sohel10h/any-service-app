import 'dart:convert';

UploadServiceRequestModel uploadServiceRequestModelFromJson(String str) => UploadServiceRequestModel.fromJson(json.decode(str));

String uploadServiceRequestModelToJson(UploadServiceRequestModel data) => json.encode(data.toJson());

class UploadServiceRequestModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  UploadServiceRequestModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory UploadServiceRequestModel.fromJson(Map<String, dynamic> json) => UploadServiceRequestModel(
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
  final String? id;
  final String? userId;
  final String? description;
  final num? budgetMin;
  final num? budgetMax;
  final int? status;
  final bool? isCorporate;
  final String? companyName;
  final String? contactPerson;
  final String? requestFrom;
  final String? requestEnd;
  final bool? isActive;
  final bool? isDeleted;
  final String? createdBy;
  final String? updatedBy;
  final String? createdOnUtc;
  final String? updatedOnUtc;
  final dynamic pictures;
  final dynamic bids;

  Data({
    this.id,
    this.userId,
    this.description,
    this.budgetMin,
    this.budgetMax,
    this.status,
    this.isCorporate,
    this.companyName,
    this.contactPerson,
    this.requestFrom,
    this.requestEnd,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.updatedBy,
    this.createdOnUtc,
    this.updatedOnUtc,
    this.pictures,
    this.bids,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        description: json["description"],
        budgetMin: json["budget_min"],
        budgetMax: json["budget_max"],
        status: json["status"],
        isCorporate: json["is_corporate"],
        companyName: json["company_name"],
        contactPerson: json["contact_person"],
        requestFrom: json["request_from"],
        requestEnd: json["request_end"],
        isActive: json["is_active"],
        isDeleted: json["is_deleted"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdOnUtc: json["created_on_utc"],
        updatedOnUtc: json["updated_on_utc"],
        pictures: json["pictures"],
        bids: json["bids"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "description": description,
        "budget_min": budgetMin,
        "budget_max": budgetMax,
        "status": status,
        "is_corporate": isCorporate,
        "company_name": companyName,
        "contact_person": contactPerson,
        "request_from": requestFrom,
        "request_end": requestEnd,
        "is_active": isActive,
        "is_deleted": isDeleted,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_on_utc": createdOnUtc,
        "updated_on_utc": updatedOnUtc,
        "pictures": pictures,
        "bids": bids,
      };
}
