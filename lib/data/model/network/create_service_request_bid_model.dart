import 'dart:convert';

CreateServiceRequestBidModel createServiceRequestBidModelFromJson(String str) => CreateServiceRequestBidModel.fromJson(json.decode(str));

String createServiceRequestBidModelToJson(CreateServiceRequestBidModel data) => json.encode(data.toJson());

class CreateServiceRequestBidModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final dynamic data;

  CreateServiceRequestBidModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory CreateServiceRequestBidModel.fromJson(Map<String, dynamic> json) => CreateServiceRequestBidModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": data,
      };
}
