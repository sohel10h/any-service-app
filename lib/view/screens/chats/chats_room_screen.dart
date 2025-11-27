import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/chats/chats_input_field.dart';
import 'package:service_la/view/widgets/chats/chats_message_bubble.dart';
import 'package:service_la/view/screens/chats/controller/chats_room_controller.dart';

class ChatsRoomScreen extends GetWidget<ChatsRoomController> {
  const ChatsRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        centerTitle: false,
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.username,
              style: TextStyle(
                fontSize: 17.sp,
                color: AppColors.text101828,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "last seen 11:59 AM",
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.text6A7282,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Video call",
            icon: const Icon(Icons.videocam_outlined, color: AppColors.black),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "Audio call",
            icon: const Icon(Icons.call_outlined, color: AppColors.black),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.black,
            ),
            offset: const Offset(-35, -1),
            position: PopupMenuPosition.under,
            onSelected: (value) {
              if (value == "settings") {
              } else if (value == "help") {}
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: "settings",
                child: Text("Settings"),
              ),
              const PopupMenuItem<String>(
                value: "help",
                child: Text("Help"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messages = controller.messages;
              return ListView.builder(
                reverse: false,
                padding: EdgeInsets.all(12.sp),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final m = messages[index];
                  return ChatsMessageBubble(
                    message: m['text'],
                    isMe: m['isMe'],
                    time: m['time'],
                  );
                },
              );
            }),
          ),
          ChatsInputField(
            controller: controller.chatInputController,
            isTyping: controller.isTyping,
            onSend: () => controller.sendMessage(controller.chatInputController.text),
            onMic: () => log("Mic pressed"),
            onEmoji: () => log("Emoji pressed"),
            onAttachment: () => log("Attachment pressed"),
            onCamera: () => log("Camera pressed"),
          ),
        ],
      ),
    );
  }
}
