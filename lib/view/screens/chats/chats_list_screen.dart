import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/view/widgets/chats/chats_tile.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/screens/chats/controller/chats_list_controller.dart';

class ChatsListScreen extends GetWidget<ChatsListController> {
  const ChatsListScreen({super.key});

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
                  Obx(() {
                    return IconButton(
                      icon: Icon(
                        controller.isSelectedPinned.value ? Icons.push_pin : Icons.push_pin_outlined,
                        color: AppColors.black,
                      ),
                      tooltip: "Pin",
                      onPressed: () {
                        controller.togglePin(controller.selectedChats);
                        controller.clearSelection();
                      },
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_outlined, color: AppColors.black),
                    tooltip: "Delete",
                    onPressed: () {
                      controller.deleteChats(controller.selectedChats);
                      controller.clearSelection();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_off_outlined, color: AppColors.black),
                    tooltip: "Notifications Off",
                    onPressed: () {
                      // disable notifications
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.archive_outlined, color: AppColors.black),
                    tooltip: "Archive",
                    onPressed: () {
                      controller.toggleArchive(controller.selectedChats);
                      controller.clearSelection();
                    },
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.black),
                    onSelected: (value) {
                      if (value == "mute") {
                        // handle mute
                      } else if (value == "delete") {
                        controller.deleteChats(controller.selectedChats);
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
                title: "Chats",
                actions: [
                  IconButton(
                    tooltip: "Camera",
                    icon: const Icon(Icons.camera_alt_outlined, color: AppColors.black),
                    onPressed: () {},
                  ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Obx(() {
                      final text = controller.searchQuery.value;
                      if (text.isEmpty) return const SizedBox.shrink();
                      return IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => controller.searchController.clear(),
                      );
                    }),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                ),
              ),
              Obx(() {
                final archivedCount = controller.archivedChats.length;
                final list = controller.filteredChats;
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshChats,
                    child: list.isEmpty && archivedCount == 0
                        ? Padding(
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
                                    "No chats yet",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.text6A7282,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Start a conversation\n and it will appear here.",
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
                            itemCount: list.length + (archivedCount > 0 ? 1 : 0),
                            separatorBuilder: (_, __) => SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              if (archivedCount > 0 && index == 0) {
                                return ListTile(
                                  contentPadding: EdgeInsets.only(left: 16.w, right: 12.w),
                                  onTap: controller.goToChatsArchivedListScreen,
                                  leading: CircleAvatar(
                                    radius: 18.r,
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(Icons.archive_outlined, size: 18.sp),
                                  ),
                                  title: Text(
                                    "Archived",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.text6A7282,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: Text(
                                    "$archivedCount",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: AppColors.text6A7282,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                );
                              }
                              final chatIndex = archivedCount > 0 ? index - 1 : index;
                              final chat = list[chatIndex];
                              return ChatsTile(
                                name: chat["name"],
                                lastMessage: chat["lastMessage"],
                                iconPath: chat["iconPath"],
                                time: chat["time"],
                                unread: chat["unread"],
                                onTap: () => controller.selectedChats.isNotEmpty
                                    ? controller.toggleSelection(chat["id"])
                                    : controller.goToChatsRoomScreen(chat["name"], id: chat["id"]),
                                onLongPress: () => controller.toggleSelection(chat["id"]),
                                isSelected: controller.selectedChats.contains(chat["id"]),
                                isPinned: chat["pinned"] == true,
                              );
                            },
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: FloatingActionButton(
            heroTag: "add_contact_fab",
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.primary,
            onPressed: () {
              controller.addNewContact(HelperFunction.userImage3);
            },
            child: const Icon(Icons.person_add_outlined),
          ),
        ),
        bottomNavigationBar: Obx(() {
          final idx = controller.selectedBottomIndex.value;
          return BottomNavigationBar(
            currentIndex: idx,
            onTap: controller.changeBottomNav,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.text6A7282,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.update_outlined),
                label: 'Updates',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined),
                label: 'Communities',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call_outlined),
                label: 'Calls',
              ),
            ],
          );
        }),
      );
    });
  }
}
