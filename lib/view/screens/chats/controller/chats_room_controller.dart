import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChatsRoomController extends GetxController {
  String username = "";
  String id = "";
  final chatInputController = TextEditingController();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    initWithConversation(id);
  }

  void initWithConversation(String chatId) {
    messages.assignAll([
      {
        "id": "m1",
        "text": "Hi! I am available now, "
            "would you like to discuss the topics last "
            "day we discussed?",
        "isMe": false,
        "time": "10:00 AM",
      },
      {
        "id": "m2",
        "text": "Hi, how are you? I need to "
            "discuss with you about the services, do you "
            "have time for me, thank you!",
        "isMe": true,
        "time": "10:01 PM",
      },
    ]);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add({
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "text": text,
      "isMe": true,
      "time": TimeOfDay.now().format(Get.context!),
    });
  }

  void _getArguments() {
    if (Get.arguments != null) {
      username = Get.arguments["username"] ?? "User";
      id = Get.arguments["id"] ?? "unknown";
    }
  }

  @override
  void onClose() {
    super.onClose();
    chatInputController.dispose();
  }
}
