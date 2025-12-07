import 'dart:convert';
import 'package:service_la/data/model/network/common/meta_model.dart';
import 'package:service_la/data/model/network/common/service_review_model.dart';

VendorReviewResponseModel vendorReviewResponseModelFromJson(String str) => VendorReviewResponseModel.fromJson(json.decode(str));

String vendorReviewResponseModelToJson(VendorReviewResponseModel data) => json.encode(data.toJson());

class VendorReviewResponseModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final VendorReviewData? vendorReviewData;

  VendorReviewResponseModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.vendorReviewData,
  });

  factory VendorReviewResponseModel.fromJson(Map<String, dynamic> json) => VendorReviewResponseModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        vendorReviewData: json["data"] == null ? null : VendorReviewData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": vendorReviewData?.toJson(),
      };
}

class VendorReviewData {
  final MetaModel? meta;
  final List<ServiceReviewModel>? serviceReviews;

  VendorReviewData({
    this.meta,
    this.serviceReviews,
  });

  factory VendorReviewData.fromJson(Map<String, dynamic> json) => VendorReviewData(
        meta: json["meta"] == null ? null : MetaModel.fromJson(json["meta"]),
        serviceReviews:
            json["users"] == null ? [] : List<ServiceReviewModel>.from(json["users"]!.map((x) => ServiceReviewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "users": serviceReviews == null ? [] : List<dynamic>.from(serviceReviews!.map((x) => x.toJson())),
      };
}
