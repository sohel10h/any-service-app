import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';

class ChatsListController extends GetxController {
  var chats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    loadChats();
    super.onInit();
  }

  void goToChatsRoomScreen(String username) => Get.toNamed(
        AppRoutes.chatsRoomScreen,
        arguments: {
          "username": username,
        },
      );

  void loadChats() {
    chats.value = [
      {"name": "John Doe", "lastMessage": "Hello, how are you?", "time": "10:24 AM", "unread": 2},
      {"name": "Sarah", "lastMessage": "Thanks!", "time": "Yesterday", "unread": 0},
    ];
  }
}
