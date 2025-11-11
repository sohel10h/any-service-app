class PictureModel {
  final String? id;
  final String? mimeType;
  final String? seoFilename;
  final String? altAttribute;
  final String? titleAttribute;
  final String? virtualPath;
  final bool? isIcon;

  PictureModel({
    this.id,
    this.mimeType,
    this.seoFilename,
    this.altAttribute,
    this.titleAttribute,
    this.virtualPath,
    this.isIcon,
  });

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
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
