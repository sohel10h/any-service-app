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

  @override
  Future getChatsMessages(String conversationId, {Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getChatsMessagesPath.replaceAll("#conversationId#", conversationId),
        queryParams: queryParams,
      ),
    );
    return response;
  }

  @override
  Future getChatsMessagesUser(String userId, {Map<String, dynamic>? queryParams}) async {
    dynamic response = await ApiService().get(
      ApiConstant.dynamicQueryParams(
        ApiConstant.getChatsMessagesUserPath.replaceAll("#userId#", userId),
        queryParams: queryParams,
      ),
    );
    return response;
  }
}
