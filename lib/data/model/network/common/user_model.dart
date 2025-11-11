class UserModel {
  final String? userId;
  final String? name;
  final String? virtualPath;
  final String? email;
  final String? mobile;

  UserModel({
    this.userId,
    this.name,
    this.virtualPath,
    this.email,
    this.mobile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["user_id"],
    name: json["name"],
    virtualPath: json["virtual_path"],
    email: json["email"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "virtual_path": virtualPath,
    "email": email,
    "mobile": mobile,
  };
}