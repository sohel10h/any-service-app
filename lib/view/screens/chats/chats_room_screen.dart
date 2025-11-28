import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/date_time/format_date.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/chats/chats_input_field.dart';
import 'package:service_la/view/widgets/chats/chats_message_bubble.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/chats/chats_message_shimmer.dart';
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
              controller.chatUsername,
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
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.white,
              onRefresh: () => controller.refreshChatsMessagesData(isRefresh: true),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
                    controller.loadNextPageChats();
                  }
                  return false;
                },
                child: Obx(() {
                  final messages = controller.chatsMessages;
                  final isLoading = controller.isLoadingChatsMessages.value;
                  final isLoadingMore = controller.isLoadingMoreChatsMessages.value;
                  if (isLoading) {
                    return ListView.separated(
                      padding: EdgeInsets.only(top: 4.h, bottom: 100.h),
                      itemCount: 10,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (_, index) {
                        final isMe = index % 2 == 0;
                        return ChatsMessageShimmer(isMe: isMe);
                      },
                    );
                  }
                  if (messages.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.message_outlined,
                              size: 64.sp,
                              color: AppColors.text6A7282,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "No chats messages yet",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.text6A7282,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Start sending messages\n and they’ll appear here instantly.",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.text6A7282.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: false,
                    padding: EdgeInsets.all(12.sp),
                    itemCount: messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
                        final m = messages[index];
                        return ChatsMessageBubble(
                          message: m.content ?? "",
                          isMe: m.senderId == controller.loginUserId,
                          time: formatChatTimestamp(DateTime.tryParse(m.createdAt ?? "")),
                        );
                      }
                      return isLoadingMore
                          ? Padding(
                              padding: EdgeInsets.all(16.sp),
                              child: const CustomProgressBar(),
                            )
                          : const SizedBox.shrink();
                    },
                  );
                }),
              ),
            ),
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
