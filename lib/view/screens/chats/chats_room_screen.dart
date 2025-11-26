import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/chats/chats_message_bubble.dart';
import 'package:service_la/view/screens/chats/controller/chats_room_controller.dart';

class ChatsRoomScreen extends GetWidget<ChatsRoomController> {
  const ChatsRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.username),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return ChatsMessageBubble(
                    message: msg["message"],
                    isMe: msg["isMe"],
                    time: msg["time"],
                  );
                },
              );
            }),
          ),
          _bottomInputBar(),
        ],
      ),
    );
  }

  Widget _bottomInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: "Type a message…",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: controller.sendButtonOnTap,
            ),
          )
        ],
      ),
    );
  }
}
