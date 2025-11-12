import 'package:service_la/data/model/network/common/vendor_model.dart';

class BidModel {
  final String? id;
  final String? serviceRequestId;
  final String? serviceId;
  final String? providerId;
  final String? vendorId;
  final String? message;
  final num? proposedPrice;
  final int? status;
  final String? createdBy;
  final String? updatedBy;
  final String? createdOnUtc;
  final String? updatedOnUtc;
  bool? isShortlisted;
  bool? userApproved;
  bool? vendorApproved;
  final String? lastStatusUpdatedBy;
  final VendorModel? vendor;

  BidModel({
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

  factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
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
        vendor: json["vendor"] == null ? null : VendorModel.fromJson(json["vendor"]),
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
        "vendor": vendor?.toJson(),
      };
}
