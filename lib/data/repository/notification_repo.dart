import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/network/notification_api_service.dart';
import 'package:service_la/data/implementation/notification_information.dart';
import 'package:service_la/data/model/network/notification_response_model.dart';

class NotificationRepo {
  final NotificationApiService _notificationApiService = NotificationInformation();

  Future<dynamic> getNotifications({Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _notificationApiService.getNotifications(queryParams: queryParams);
      log("Notifications get details from notification repo: $response");
      return NotificationResponseModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
