import 'package:service_la/data/model/network/common/picture_model.dart';

class CategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final String? metaKeywords;
  final String? metaDescription;
  final String? metaTitle;
  final String? parentCategoryId;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final bool? showInHomepage;
  final PictureModel? picture;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.metaKeywords,
    this.metaDescription,
    this.metaTitle,
    this.parentCategoryId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.showInHomepage,
    this.picture,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        metaKeywords: json["meta_keywords"],
        metaDescription: json["meta_description"],
        metaTitle: json["meta_title"],
        parentCategoryId: json["parent_category_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        showInHomepage: json["show_in_homepage"],
        picture: json["picture"] == null ? null : PictureModel.fromJson(json["picture"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "meta_keywords": metaKeywords,
        "meta_description": metaDescription,
        "meta_title": metaTitle,
        "parent_category_id": parentCategoryId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "show_in_homepage": showInHomepage,
        "picture": picture?.toJson(),
      };
}
