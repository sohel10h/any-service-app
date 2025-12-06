import 'dart:convert';
import 'package:service_la/data/model/network/common/service_details_model.dart';

UploadServiceRequestResponseModel uploadServiceRequestResponseModelFromJson(String str) =>
    UploadServiceRequestResponseModel.fromJson(json.decode(str));

String uploadServiceRequestResponseModelToJson(UploadServiceRequestResponseModel data) => json.encode(data.toJson());

class UploadServiceRequestResponseModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final ServiceDetailsData? serviceDetailsData;

  UploadServiceRequestResponseModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.serviceDetailsData,
  });

  factory UploadServiceRequestResponseModel.fromJson(Map<String, dynamic> json) => UploadServiceRequestResponseModel(
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
