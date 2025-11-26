import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/chats/chats_tile.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/screens/chats/controller/chats_list_controller.dart';

class ChatsListScreen extends GetWidget<ChatsListController> {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Chat",
      ),
      body: Obx(() {
        return ListView.separated(
          itemCount: controller.chats.length,
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemBuilder: (context, index) {
            final chat = controller.chats[index];
            return ChatsTile(
              name: chat["name"],
              lastMessage: chat["lastMessage"],
              time: chat["time"],
              unread: chat["unread"],
              onTap: () => controller.goToChatsRoomScreen(chat["name"]),
            );
          },
        );
      }),
    );
  }
}
