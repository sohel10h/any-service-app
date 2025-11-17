import 'dart:convert';

class WebsocketBidModel {
  final String? bidId;
  final String? message;
  final int? proposedPrice;
  final String? providerId;
  final String? serviceRequestId;
  final int? type;
  final String? userId;

  WebsocketBidModel({
    this.bidId,
    this.message,
    this.proposedPrice,
    this.providerId,
    this.serviceRequestId,
    this.type,
    this.userId,
  });

  factory WebsocketBidModel.fromJson(Map<String, dynamic> json) {
    return WebsocketBidModel(
      bidId: json['BidID'] ?? '',
      message: json['Message'] ?? '',
      proposedPrice: json['ProposedPrice'] ?? 0,
      providerId: json['ProviderID'] ?? '',
      serviceRequestId: json['ServiceRequestID'] ?? '',
      type: json['Type'] ?? 0,
      userId: json['UserID'] ?? '',
    );
  }

  factory WebsocketBidModel.fromApiResponse(Map<String, dynamic> response) {
    final dataString = response["notification"]?["data"];
    final Map<String, dynamic> decoded = jsonDecode(dataString);
    return WebsocketBidModel.fromJson(decoded);
  }

  Map<String, dynamic> toJson() {
    return {
      'BidID': bidId,
      'Message': message,
      'ProposedPrice': proposedPrice,
      'ProviderID': providerId,
      'ServiceRequestID': serviceRequestId,
      'Type': type,
      'UserID': userId,
    };
  }
}
