class ReviewModel {
  final String? id;
  final String? userId;
  final String? vendorId;
  final String? serviceId;
  final String? serviceRequestId;
  final String? serviceRequestBidId;
  final num? rating;
  final String? reviewText;
  final String? createdAt;
  final String? updatedAt;

  ReviewModel({
    this.id,
    this.userId,
    this.vendorId,
    this.serviceId,
    this.serviceRequestId,
    this.serviceRequestBidId,
    this.rating,
    this.reviewText,
    this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        userId: json["user_id"],
        vendorId: json["vendor_id"],
        serviceId: json["service_id"],
        serviceRequestId: json["service_request_id"],
        serviceRequestBidId: json["service_request_bid_id"],
        rating: json["rating"],
        reviewText: json["review_text"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "vendor_id": vendorId,
        "service_id": serviceId,
        "service_request_id": serviceRequestId,
        "service_request_bid_id": serviceRequestBidId,
        "rating": rating,
        "review_text": reviewText,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
