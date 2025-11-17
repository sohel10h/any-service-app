import 'dart:convert';

class WebsocketVendorModel {
  final String? data;
  final String? id;
  final int? type;
  final String? userId;

  WebsocketVendorModel({
    this.data,
    this.id,
    this.type,
    this.userId,
  });

  factory WebsocketVendorModel.fromJson(Map<String, dynamic> json) {
    return WebsocketVendorModel(
      data: json['Data'] ?? '',
      id: json['ID'] ?? '',
      type: json['Type'] ?? 0,
      userId: json['UserID'] ?? '',
    );
  }

  factory WebsocketVendorModel.fromApiResponse(Map<String, dynamic> response) {
    final dataString = response["notification"]?["data"];
    final Map<String, dynamic> decoded = jsonDecode(dataString);
    return WebsocketVendorModel.fromJson(decoded);
  }

  Map<String, dynamic> toJson() {
    return {
      'Data': data,
      'ID': id,
      'Type': type,
      'UserID': userId,
    };
  }
}
