import 'package:service_la/data/model/network/common/review_model.dart';
import 'package:service_la/data/model/network/common/picture_model.dart';
import 'package:service_la/data/model/network/common/service_user_model.dart';

class ServiceReviewModel {
  final ReviewModel? review;
  final ServiceUserModel? user;
  final PictureModel? picture;

  ServiceReviewModel({
    this.review,
    this.user,
    this.picture,
  });

  factory ServiceReviewModel.fromJson(Map<String, dynamic> json) => ServiceReviewModel(
        review: json["review"] == null ? null : ReviewModel.fromJson(json["review"]),
        user: json["user"] == null ? null : ServiceUserModel.fromJson(json["user"]),
        picture: json["picture"] == null ? null : PictureModel.fromJson(json["picture"]),
      );

  Map<String, dynamic> toJson() => {
        "review": review?.toJson(),
        "user": user?.toJson(),
        "picture": picture?.toJson(),
      };
}
