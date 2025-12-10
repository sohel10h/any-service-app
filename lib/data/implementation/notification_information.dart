import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/network/notification_api_service.dart';

class NotificationInformation extends NotificationApiService {
  @override
  Future getNotifications({Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getNotificationsPath,
        queryParams: queryParams,
      ),
    );
    return response;
  }
}
