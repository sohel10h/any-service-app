import 'dart:convert';

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
  final List<Category>? categories;
  final List<ServiceDetailsPicture>? pictures;
  final List<Bid>? bids;
  final User? user;

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
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        pictures: json["pictures"] == null
            ? []
            : List<ServiceDetailsPicture>.from(json["pictures"]!.map((x) => ServiceDetailsPicture.fromJson(x))),
        bids: json["bids"] == null ? [] : List<Bid>.from(json["bids"]!.map((x) => Bid.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
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

class Bid {
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
  final bool? isShortlisted;
  final bool? userApproved;
  final bool? vendorApproved;
  final String? lastStatusUpdatedBy;
  final Vendor? vendor;

  Bid({
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

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
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
        vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
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

class Vendor {
  final String? name;
  final String? virtualPath;
  final int? rating;
  final int? serviceCompletedCount;

  Vendor({
    this.name,
    this.virtualPath,
    this.rating,
    this.serviceCompletedCount,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        name: json["name"],
        virtualPath: json["virtual_path"],
        rating: json["rating"],
        serviceCompletedCount: json["service_completed_count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "virtual_path": virtualPath,
        "rating": rating,
        "service_completed_count": serviceCompletedCount,
      };
}

class Category {
  final String? id;
  final String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ServiceDetailsPicture {
  final String? id;
  final String? mimeType;
  final String? seoFilename;
  final String? altAttribute;
  final String? titleAttribute;
  final String? virtualPath;
  final bool? isIcon;

  ServiceDetailsPicture({
    this.id,
    this.mimeType,
    this.seoFilename,
    this.altAttribute,
    this.titleAttribute,
    this.virtualPath,
    this.isIcon,
  });

  factory ServiceDetailsPicture.fromJson(Map<String, dynamic> json) => ServiceDetailsPicture(
        id: json["id"],
        mimeType: json["mime_type"],
        seoFilename: json["seo_filename"],
        altAttribute: json["alt_attribute"],
        titleAttribute: json["title_attribute"],
        virtualPath: json["virtual_path"],
        isIcon: json["is_icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mime_type": mimeType,
        "seo_filename": seoFilename,
        "alt_attribute": altAttribute,
        "title_attribute": titleAttribute,
        "virtual_path": virtualPath,
        "is_icon": isIcon,
      };
}

class User {
  final String? userId;
  final String? name;
  final String? virtualPath;
  final String? email;
  final String? mobile;

  User({
    this.userId,
    this.name,
    this.virtualPath,
    this.email,
    this.mobile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        name: json["name"],
        virtualPath: json["virtual_path"],
        email: json["email"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "virtual_path": virtualPath,
        "email": email,
        "mobile": mobile,
      };
}
