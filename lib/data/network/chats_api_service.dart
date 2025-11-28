abstract class ChatsApiService {
  Future<dynamic> getChats({Map<String, dynamic>? queryParams});

  Future<dynamic> getChatsMessages(String conversationId, {Map<String, dynamic>? queryParams});
}
