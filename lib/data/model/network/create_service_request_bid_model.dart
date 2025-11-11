import 'dart:convert';

CreateServiceRequestBidModel createServiceRequestBidModelFromJson(String str) => CreateServiceRequestBidModel.fromJson(json.decode(str));

String createServiceRequestBidModelToJson(CreateServiceRequestBidModel data) => json.encode(data.toJson());

class CreateServiceRequestBidModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final CreateServiceRequestBidData? data;

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
        data: json["data"] == null ? null : CreateServiceRequestBidData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": data?.toJson(),
      };
}

class CreateServiceRequestBidData {
  final String? id;
  final String? serviceRequestId;
  final String? serviceId;
  final String? providerId;
  final String? vendorId;
  final String? message;
  final int? proposedPrice;
  final int? status;
  final String? createdBy;
  final String? updatedBy;
  final String? createdOnUtc;
  final String? updatedOnUtc;
  final bool? isShortlisted;
  final bool? userApproved;
  final bool? vendorApproved;
  final String? lastStatusUpdatedBy;
  final dynamic vendor;

  CreateServiceRequestBidData({
    this.id,
    this.serviceRequestId,
    this.serviceId,
    this.providerId,
    this.vendorId,
    this.message,
    this.proposedPrice,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdOnUtc,
    this.updatedOnUtc,
    this.isShortlisted,
    this.userApproved,
    this.vendorApproved,
    this.lastStatusUpdatedBy,
    this.vendor,
  });

  factory CreateServiceRequestBidData.fromJson(Map<String, dynamic> json) => CreateServiceRequestBidData(
        id: json["id"],
        serviceRequestId: json["service_request_id"],
        serviceId: json["service_id"],
        providerId: json["provider_id"],
        vendorId: json["vendor_id"],
        message: json["message"],
        proposedPrice: json["proposed_price"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdOnUtc: json["created_on_utc"],
        updatedOnUtc: json["updated_on_utc"],
        isShortlisted: json["is_shortlisted"],
        userApproved: json["user_approved"],
        vendorApproved: json["vendor_approved"],
        lastStatusUpdatedBy: json["last_status_updated_by"],
        vendor: json["vendor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_request_id": serviceRequestId,
        "service_id": serviceId,
        "provider_id": providerId,
        "vendor_id": vendorId,
        "message": message,
        "proposed_price": proposedPrice,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_on_utc": createdOnUtc,
        "updated_on_utc": updatedOnUtc,
        "is_shortlisted": isShortlisted,
        "user_approved": userApproved,
        "vendor_approved": vendorApproved,
        "last_status_updated_by": lastStatusUpdatedBy,
        "vendor": vendor,
      };
}
