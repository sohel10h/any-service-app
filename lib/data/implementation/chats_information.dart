import 'package:service_la/data/network/chats_api_service.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_service/api_service.dart';

class ChatsInformation extends ChatsApiService {
  @override
  Future getChats({Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getChatsPath,
        queryParams: queryParams,
      ),
    );
    return response;
  }
}
