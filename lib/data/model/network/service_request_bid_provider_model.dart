import 'dart:convert';

ServiceRequestBidProviderModel serviceRequestBidProviderModelFromJson(String str) =>
    ServiceRequestBidProviderModel.fromJson(json.decode(str));

String serviceRequestBidProviderModelToJson(ServiceRequestBidProviderModel data) => json.encode(data.toJson());

class ServiceRequestBidProviderModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final ServiceRequestBidData? serviceRequestBidData;

  ServiceRequestBidProviderModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.serviceRequestBidData,
  });

  factory ServiceRequestBidProviderModel.fromJson(Map<String, dynamic> json) => ServiceRequestBidProviderModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        serviceRequestBidData: json["data"] == null ? null : ServiceRequestBidData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": serviceRequestBidData?.toJson(),
      };
}

class ServiceRequestBidData {
  final Meta? meta;
  final List<ServiceRequestBid>? serviceRequestBids;

  ServiceRequestBidData({
    this.meta,
    this.serviceRequestBids,
  });

  factory ServiceRequestBidData.fromJson(Map<String, dynamic> json) => ServiceRequestBidData(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        serviceRequestBids: json["bids"] == null
            ? []
            : List<ServiceRequestBid>.from(json["bids"]!.map(
                (x) => ServiceRequestBid.fromJson(x),
              )),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "bids": serviceRequestBids == null ? [] : List<dynamic>.from(serviceRequestBids!.map((x) => x.toJson())),
      };
}

class ServiceRequestBid {
  final String? serviceRequestId;
  final String? bidId;
  final String? serviceRequestTitle;
  final String? serviceRequestUserId;
  final String? serviceRequestUser;
  final String? bidCreatedOn;
  final int? bidStatus;
  final num? proposedPrice;
  final bool? userApproved;
  final bool? vendorApproved;
  final int? serviceRequestStatus;

  ServiceRequestBid({
    this.serviceRequestId,
    this.bidId,
    this.serviceRequestTitle,
    this.serviceRequestUserId,
    this.serviceRequestUser,
    this.bidCreatedOn,
    this.bidStatus,
    this.proposedPrice,
    this.userApproved,
    this.vendorApproved,
    this.serviceRequestStatus,
  });

  factory ServiceRequestBid.fromJson(Map<String, dynamic> json) => ServiceRequestBid(
        serviceRequestId: json["service_request_id"],
        bidId: json["bid_id"],
        serviceRequestTitle: json["service_request_title"],
        serviceRequestUserId: json["service_request_user_id"],
        serviceRequestUser: json["service_request_user"],
        bidCreatedOn: json["bid_created_on"],
        bidStatus: json["bid_status"],
        proposedPrice: json["proposed_price"],
        userApproved: json["user_approved"],
        vendorApproved: json["vendor_approved"],
        serviceRequestStatus: json["service_request_status"],
      );

  Map<String, dynamic> toJson() => {
        "service_request_id": serviceRequestId,
        "bid_id": bidId,
        "service_request_title": serviceRequestTitle,
        "service_request_user_id": serviceRequestUserId,
        "service_request_user": serviceRequestUser,
        "bid_created_on": bidCreatedOn,
        "bid_status": bidStatus,
        "proposed_price": proposedPrice,
        "user_approved": userApproved,
        "vendor_approved": vendorApproved,
        "service_request_status": serviceRequestStatus,
      };
}

class Meta {
  final int? page;
  final int? pageSize;
  final int? totalItems;
  final int? totalPages;

  Meta({
    this.page,
    this.pageSize,
    this.totalItems,
    this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"],
        pageSize: json["page_size"],
        totalItems: json["total_items"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "page_size": pageSize,
        "total_items": totalItems,
        "total_pages": totalPages,
      };
}
