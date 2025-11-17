import 'dart:convert';

class WebsocketServiceRequestModel {
  final String? data;
  final String? id;
  final int? type;
  final String? userId;

  WebsocketServiceRequestModel({
    this.data,
    this.id,
    this.type,
    this.userId,
  });

  factory WebsocketServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return WebsocketServiceRequestModel(
      data: json['Data'] ?? '',
      id: json['ID'] ?? '',
      type: json['Type'] ?? 0,
      userId: json['UserID'] ?? '',
    );
  }

  factory WebsocketServiceRequestModel.fromApiResponse(Map<String, dynamic> response) {
    final dataString = response["notification"]?["data"];
    final Map<String, dynamic> decoded = jsonDecode(dataString);
    return WebsocketServiceRequestModel.fromJson(decoded);
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
