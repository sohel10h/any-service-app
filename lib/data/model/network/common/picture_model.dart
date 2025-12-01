class PictureModel {
  final String? id;
  final String? mimeType;
  final String? seoFilename;
  final String? altAttribute;
  final String? titleAttribute;
  final String? virtualPath;
  final String? createdBy;
  final String? updatedBy;
  final String? createdOnUtc;
  final String? updatedOnUtc;
  final int? displayOrder;
  final bool? isIcon;

  PictureModel({
    this.id,
    this.mimeType,
    this.seoFilename,
    this.altAttribute,
    this.titleAttribute,
    this.virtualPath,
    this.createdBy,
    this.updatedBy,
    this.createdOnUtc,
    this.updatedOnUtc,
    this.displayOrder,
    this.isIcon,
  });

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
        id: json["id"],
        mimeType: json["mime_type"],
        seoFilename: json["seo_filename"],
        altAttribute: json["alt_attribute"],
        titleAttribute: json["title_attribute"],
        virtualPath: json["virtual_path"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdOnUtc: json["created_on_utc"],
        updatedOnUtc: json["updated_on_utc"],
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
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_on_utc": createdOnUtc,
        "updated_on_utc": updatedOnUtc,
        "display_order": displayOrder,
        "is_icon": isIcon,
      };
}
