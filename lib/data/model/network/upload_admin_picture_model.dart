import 'dart:convert';

UploadAdminPictureModel uploadAdminPictureModelFromJson(String str) => UploadAdminPictureModel.fromJson(json.decode(str));

String uploadAdminPictureModelToJson(UploadAdminPictureModel data) => json.encode(data.toJson());

class UploadAdminPictureModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final Data? data;

  UploadAdminPictureModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory UploadAdminPictureModel.fromJson(Map<String, dynamic> json) => UploadAdminPictureModel(
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
  final String? mimeType;
  final String? seoFilename;
  final String? altAttribute;
  final String? titleAttribute;
  final String? virtualPath;

  Data({
    this.id,
    this.mimeType,
    this.seoFilename,
    this.altAttribute,
    this.titleAttribute,
    this.virtualPath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        mimeType: json["mime_type"],
        seoFilename: json["seo_filename"],
        altAttribute: json["alt_attribute"],
        titleAttribute: json["title_attribute"],
        virtualPath: json["virtual_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mime_type": mimeType,
        "seo_filename": seoFilename,
        "alt_attribute": altAttribute,
        "title_attribute": titleAttribute,
        "virtual_path": virtualPath,
      };
}
