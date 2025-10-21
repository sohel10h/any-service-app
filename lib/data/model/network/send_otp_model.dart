import 'dart:convert';

SendOtpModel sendOtpModelFromJson(String str) => SendOtpModel.fromJson(json.decode(str));

String sendOtpModelToJson(SendOtpModel data) => json.encode(data.toJson());

class SendOtpModel {
  final bool? isSuccess;
  final int? status;
  final dynamic errors;
  final dynamic data;

  SendOtpModel({
    this.isSuccess,
    this.status,
    this.errors,
    this.data,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
        isSuccess: json["isSuccess"],
        status: json["status"],
        errors: json["errors"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "status": status,
        "errors": errors,
        "data": data,
      };
}
