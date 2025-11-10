import 'dart:convert';

ServiceMeModel serviceMeModelFromJson(String str) => ServiceMeModel.fromJson(json.decode(str));

String serviceMeModelToJson(ServiceMeModel data) => json.encode(data.toJson());

class ServiceMeModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final List<ServiceMeData>? serviceMeData;

  ServiceMeModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.serviceMeData,
  });

  factory ServiceMeModel.fromJson(Map<String, dynamic> json) => ServiceMeModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        serviceMeData: json["data"] == null ? [] : List<ServiceMeData>.from(json["data"]!.map((x) => ServiceMeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": serviceMeData == null ? [] : List<dynamic>.from(serviceMeData!.map((x) => x.toJson())),
      };
}

class ServiceMeData {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final bool? priceRange;
  final int? priceStart;
  final int? priceEnd;
  final int? rating;
  final int? serviceCompletedCount;
  final int? totalReview;
  final Picture? picture;

  ServiceMeData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.priceRange,
    this.priceStart,
    this.priceEnd,
    this.rating,
    this.serviceCompletedCount,
    this.totalReview,
    this.picture,
  });

  factory ServiceMeData.fromJson(Map<String, dynamic> json) => ServiceMeData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        priceRange: json["price_range"],
        priceStart: json["price_start"],
        priceEnd: json["price_end"],
        rating: json["rating"],
        serviceCompletedCount: json["service_completed_count"],
        totalReview: json["total_review"],
        picture: json["picture"] == null ? null : Picture.fromJson(json["picture"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "price_range": priceRange,
        "price_start": priceStart,
        "price_end": priceEnd,
        "rating": rating,
        "service_completed_count": serviceCompletedCount,
        "total_review": totalReview,
        "picture": picture?.toJson(),
      };
}

class Picture {
  final String? id;
  final String? mimeType;
  final String? seoFilename;
  final String? altAttribute;
  final String? titleAttribute;
  final String? virtualPath;
  final int? displayOrder;
  final bool? isIcon;

  Picture({
    this.id,
    this.mimeType,
    this.seoFilename,
    this.altAttribute,
    this.titleAttribute,
    this.virtualPath,
    this.displayOrder,
    this.isIcon,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        id: json["id"],
        mimeType: json["mime_type"],
        seoFilename: json["seo_filename"],
        altAttribute: json["alt_attribute"],
        titleAttribute: json["title_attribute"],
        virtualPath: json["virtual_path"],
        displayOrder: json["display_order"],
        isIcon: json["is_icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mime_type": mimeType,
        "seo_filename": seoFilename,
        "alt_attribute": altAttribute,
        "title_attribute": titleAttribute,
        "virtual_path": virtualPath,
        "display_order": displayOrder,
        "is_icon": isIcon,
      };
}
