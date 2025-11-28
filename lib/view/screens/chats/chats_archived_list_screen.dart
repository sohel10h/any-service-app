import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/view/widgets/chats/chats_tile.dart';
import 'package:service_la/common/utils/date_time/format_date.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/screens/chats/controller/chats_list_controller.dart';

class ChatsArchivedListScreen extends GetWidget<ChatsListController> {
  const ChatsArchivedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelectionMode = controller.isSelectionMode;
      return Scaffold(
        appBar: isSelectionMode
            ? AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.black),
                  onPressed: controller.clearSelection,
                ),
                title: Text(
                  "${controller.selectedChats.length}",
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: AppColors.text101828,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline_outlined, color: AppColors.black),
                    tooltip: "Delete",
                    onPressed: () {
                      controller.deleteArchivedChats(controller.selectedChats);
                      controller.clearSelection();
                    },
                  ),
                  Obx(() {
                    return IconButton(
                      icon: Icon(
                        controller.isSelectedPinned.value ? Icons.archive_outlined : Icons.unarchive_outlined,
                        color: AppColors.black,
                      ),
                      tooltip: "Archive",
                      onPressed: () {
                        controller.toggleArchive(controller.selectedChats);
                        controller.clearSelection();
                      },
                    );
                  }),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.black),
                    onSelected: (value) {
                      if (value == "mute") {
                        // handle mute
                      } else if (value == "delete") {
                        controller.deleteArchivedChats(controller.selectedChats);
                        controller.clearSelection();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: "mute", child: Text("Mute")),
                      const PopupMenuItem(value: "delete", child: Text("Delete")),
                    ],
                  ),
                ],
              )
            : CustomAppbar(
                title: "Archived",
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.black),
                    offset: const Offset(-35, -1),
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: "settings", child: Text("Settings")),
                      const PopupMenuItem(value: "help", child: Text("Help")),
                    ],
                  ),
                ],
              ),
        body: SafeArea(
          child: Column(
            children: [
              Obx(() {
                for (var c in controller.archivedChats) {
                  c.archived = true;
                }
                final list = controller.archivedChats;
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshChats,
                    child: list.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 64.sp,
                                    color: AppColors.text6A7282,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    "No archived chats yet",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.text6A7282,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Archived chats will appear here\n once you move them.",
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
                          )
                        : ListView.separated(
                            padding: EdgeInsets.only(top: 4.h, bottom: 100.h),
                            itemCount: list.length,
                            separatorBuilder: (_, __) => SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              final chat = list[index];
                              return ChatsTile(
                                name: chat.lastMessage?.senderName ?? "",
                                lastMessage: chat.lastMessage?.content ?? "",
                                iconPath: HelperFunction.userImage7,
                                time: formatChatTimestamp(DateTime.tryParse(chat.lastMessage?.createdAt ?? "")),
                                unread: 2,
                                // TODO: need this value from API
                                onTap: () => controller.selectedChats.isNotEmpty
                                    ? controller.toggleSelection(chat.id ?? "")
                                    : controller.goToChatsRoomScreen(
                                        chat.lastMessage?.senderName ?? "",
                                        conversationId: chat.id ?? "",
                                      ),
                                onLongPress: () => controller.toggleSelection(chat.id ?? ""),
                                isSelected: controller.selectedChats.contains(chat.id ?? ""),
                              );
                            },
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
