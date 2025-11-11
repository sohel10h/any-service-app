import 'dart:convert';
import 'package:service_la/data/model/network/common/bid_model.dart';

CreateServiceRequestBidModel createServiceRequestBidModelFromJson(String str) => CreateServiceRequestBidModel.fromJson(json.decode(str));

String createServiceRequestBidModelToJson(CreateServiceRequestBidModel data) => json.encode(data.toJson());

class CreateServiceRequestBidModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final BidModel? bid;

  CreateServiceRequestBidModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.bid,
  });

  factory CreateServiceRequestBidModel.fromJson(Map<String, dynamic> json) => CreateServiceRequestBidModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        bid: json["data"] == null ? null : BidModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": bid?.toJson(),
      };
}
