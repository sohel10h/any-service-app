import 'dart:convert';
import 'dart:developer';
import 'package:service_la/data/model/network/chat_model.dart';
import 'package:service_la/data/network/chats_api_service.dart';
import 'package:service_la/data/implementation/chats_information.dart';

class ChatsRepo {
  final ChatsApiService _chatsApiService = ChatsInformation();

  Future<dynamic> getChats({Map<String, dynamic>? queryParams}) async {
    try {
      dynamic response = await _chatsApiService.getChats(queryParams: queryParams);
      log("Chats get details from chats repo: $response");
      return ChatModel.fromJson(jsonDecode(response.toString()));
    } catch (e) {
      return e;
    }
  }
}
