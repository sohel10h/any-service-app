import 'dart:convert';
import 'package:service_la/data/model/network/common/bid_model.dart';
import 'package:service_la/data/model/network/common/user_model.dart';
import 'package:service_la/data/model/network/common/picture_model.dart';
import 'package:service_la/data/model/network/common/category_model.dart';

ServiceDetailsModel serviceDetailsModelFromJson(String str) => ServiceDetailsModel.fromJson(json.decode(str));

String serviceDetailsModelToJson(ServiceDetailsModel data) => json.encode(data.toJson());

class ServiceDetailsModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final ServiceDetailsData? serviceDetailsData;

  ServiceDetailsModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.serviceDetailsData,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) => ServiceDetailsModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        serviceDetailsData: json["data"] == null ? null : ServiceDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": serviceDetailsData?.toJson(),
      };
}

class ServiceDetailsData {
  final String? id;
  final String? userId;
  final String? title;
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
  final List<CategoryModel>? categories;
  final List<PictureModel>? pictures;
  final List<BidModel>? bids;
  final UserModel? user;

  ServiceDetailsData({
    this.id,
    this.userId,
    this.title,
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
    this.categories,
    this.pictures,
    this.bids,
    this.user,
  });

  factory ServiceDetailsData.fromJson(Map<String, dynamic> json) => ServiceDetailsData(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
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
        categories: json["categories"] == null ? [] : List<CategoryModel>.from(json["categories"]!.map((x) => CategoryModel.fromJson(x))),
        pictures: json["pictures"] == null ? [] : List<PictureModel>.from(json["pictures"]!.map((x) => PictureModel.fromJson(x))),
        bids: json["bids"] == null ? [] : List<BidModel>.from(json["bids"]!.map((x) => BidModel.fromJson(x))),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
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
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "pictures": pictures == null ? [] : List<dynamic>.from(pictures!.map((x) => x.toJson())),
        "bids": bids == null ? [] : List<dynamic>.from(bids!.map((x) => x.toJson())),
        "user": user?.toJson(),
      };
}
