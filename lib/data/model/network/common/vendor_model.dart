class VendorModel {
  final String? id;
  final String? name;
  final String? virtualPath;
  final num? rating;
  final int? serviceCompletedCount;

  VendorModel({
    this.id,
    this.name,
    this.virtualPath,
    this.rating,
    this.serviceCompletedCount,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        id: json["id"],
        name: json["name"],
        virtualPath: json["virtual_path"],
        rating: json["rating"],
        serviceCompletedCount: json["service_completed_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "virtual_path": virtualPath,
        "rating": rating,
        "service_completed_count": serviceCompletedCount,
      };
}
