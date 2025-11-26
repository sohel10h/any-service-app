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
    return Scaffold(
      appBar: CustomAppbar(
        title: "Chats",
        actions: [
          IconButton(
            tooltip: "Camera",
            icon: const Icon(Icons.camera_alt_outlined, color: AppColors.black),
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
              return Visibility(
                visible: archivedCount > 0,
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 16.w, right: 12.w),
                  onTap: () {
                    Get.toNamed('/archived_list');
                  },
                  leading: CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.archive_outlined, size: 18.sp),
                  ),
                  title: const Text("Archived"),
                  trailing: Text(
                    archivedCount == 0 ? "No archived chats" : "$archivedCount chats",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.text6A7282,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              );
            }),
            Expanded(
              child: Obx(() {
                final list = controller.filteredChats;
                return RefreshIndicator(
                  onRefresh: controller.refreshChats,
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 4.h, bottom: 100.h),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final chat = list[index];
                      return ChatsTile(
                        name: chat["name"],
                        lastMessage: chat["lastMessage"],
                        iconPath: chat["iconPath"],
                        time: chat["time"],
                        unread: chat["unread"],
                        onTap: () => controller.goToChatsRoomScreen(chat["name"], id: chat["id"]),
                        // if ChatsTile supports onLongPress, we could show archive
                        //onLongPress: () => controller.toggleArchive(chat["id"]),
                      );
                    },
                  ),
                );
              }),
            ),
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
  }
}
