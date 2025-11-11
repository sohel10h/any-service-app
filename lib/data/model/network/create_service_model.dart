import 'dart:convert';

CreateServiceModel createServiceModelFromJson(String str) => CreateServiceModel.fromJson(json.decode(str));

String createServiceModelToJson(CreateServiceModel data) => json.encode(data.toJson());

class CreateServiceModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  CreateServiceModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory CreateServiceModel.fromJson(Map<String, dynamic> json) => CreateServiceModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": data?.toJson(),
      };
}

class Data {
  final String? id;
  final String? name;
  final num? price;
  final List<dynamic>? categories;
  final String? description;
  final String? createdBy;
  final String? updatedBy;
  final bool? priceRange;
  final num? priceStart;
  final num? priceEnd;
  final String? createdAt;
  final String? updatedAt;
  final List<Picture>? pictures;

  Data({
    this.id,
    this.name,
    this.price,
    this.categories,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.priceRange,
    this.priceStart,
    this.priceEnd,
    this.createdAt,
    this.updatedAt,
    this.pictures,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        categories: json["categories"] == null ? [] : List<dynamic>.from(json["categories"]!.map((x) => x)),
        description: json["description"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        priceRange: json["price_range"],
        priceStart: json["price_start"],
        priceEnd: json["price_end"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pictures: json["pictures"] == null ? [] : List<Picture>.from(json["pictures"]!.map((x) => Picture.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x)),
        "description": description,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "price_range": priceRange,
        "price_start": priceStart,
        "price_end": priceEnd,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pictures": pictures == null ? [] : List<dynamic>.from(pictures!.map((x) => x.toJson())),
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

  Picture({
    this.id,
    this.mimeType,
    this.seoFilename,
    this.altAttribute,
    this.titleAttribute,
    this.virtualPath,
    this.displayOrder,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        id: json["id"],
        mimeType: json["mime_type"],
        seoFilename: json["seo_filename"],
        altAttribute: json["alt_attribute"],
        titleAttribute: json["title_attribute"],
        virtualPath: json["virtual_path"],
        displayOrder: json["display_order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mime_type": mimeType,
        "seo_filename": seoFilename,
        "alt_attribute": altAttribute,
        "title_attribute": titleAttribute,
        "virtual_path": virtualPath,
        "display_order": displayOrder,
      };
}
