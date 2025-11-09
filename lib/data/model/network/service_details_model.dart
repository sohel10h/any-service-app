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
  final int? budgetMin;
  final int? budgetMax;
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
  final List<ServiceDetailsCategory>? categories;
  final List<ServiceDetailsPicture>? pictures;
  final dynamic bids;
  final ServiceDetailsUser? user;

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
        categories: json["categories"] == null
            ? []
            : List<ServiceDetailsCategory>.from(json["categories"]!.map((x) => ServiceDetailsCategory.fromJson(x))),
        pictures: json["pictures"] == null
            ? []
            : List<ServiceDetailsPicture>.from(json["pictures"]!.map((x) => ServiceDetailsPicture.fromJson(x))),
        bids: json["bids"],
        user: json["user"] == null ? null : ServiceDetailsUser.fromJson(json["user"]),
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
        "bids": bids,
        "user": user?.toJson(),
      };
}

class ServiceDetailsCategory {
  final String? id;
  final String? name;

  ServiceDetailsCategory({
    this.id,
    this.name,
  });

  factory ServiceDetailsCategory.fromJson(Map<String, dynamic> json) => ServiceDetailsCategory(
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

class ServiceDetailsUser {
  final String? userId;
  final String? name;
  final String? virtualPath;
  final String? email;
  final String? mobile;

  ServiceDetailsUser({
    this.userId,
    this.name,
    this.virtualPath,
    this.email,
    this.mobile,
  });

  factory ServiceDetailsUser.fromJson(Map<String, dynamic> json) => ServiceDetailsUser(
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
