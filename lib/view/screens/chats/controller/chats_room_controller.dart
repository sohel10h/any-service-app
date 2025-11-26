import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChatsRoomController extends GetxController {
  String username = "";
  final textController = TextEditingController();
  var messages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
  }

  void sendButtonOnTap() {
    sendMessage(textController.text);
    textController.clear();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add({
      "message": text,
      "isMe": true,
      "time": DateTime.now().toString().substring(11, 16),
    });
  }

  void _getArguments() {
    if (Get.arguments != null) {
      username = Get.arguments["username"];
    }
  }

  @override
  void onClose() {
    super.onClose();
    textController.dispose();
  }
}
