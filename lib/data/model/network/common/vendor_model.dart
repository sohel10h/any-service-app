class VendorModel {
  final String? name;
  final String? virtualPath;
  final int? rating;
  final int? serviceCompletedCount;

  VendorModel({
    this.name,
    this.virtualPath,
    this.rating,
    this.serviceCompletedCount,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        name: json["name"],
        virtualPath: json["virtual_path"],
        rating: json["rating"],
        serviceCompletedCount: json["service_completed_count"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "virtual_path": virtualPath,
        "rating": rating,
        "service_completed_count": serviceCompletedCount,
      };
}
