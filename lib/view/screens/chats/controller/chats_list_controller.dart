import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/helper_function.dart';

class ChatsListController extends GetxController {
  final RxList<Map<String, dynamic>> chats = <Map<String, dynamic>>[
    {
      "id": "1",
      "name": "Jack",
      "lastMessage": "Hello, how are you?",
      "iconPath": HelperFunction.userImage1,
      "time": "10:24 AM",
      "unread": 2,
      "archived": false,
    },
    {
      "id": "2",
      "name": "Dan",
      "lastMessage": "Thanks!",
      "iconPath": HelperFunction.userImage2,
      "time": "Yesterday",
      "unread": 0,
      "archived": false,
    },
    {
      "id": "3",
      "name": "Archived User",
      "lastMessage": "Archived message",
      "iconPath": HelperFunction.userImage3,
      "time": "Nov 20",
      "unread": 0,
      "archived": true,
    },
    {
      "id": "4",
      "name": "Mike",
      "lastMessage": "Nice to meet you!, what are you doing now?",
      "iconPath": HelperFunction.userImage4,
      "time": "Sept 11",
      "unread": 5,
      "archived": false,
    },
    {
      "id": "5",
      "name": "Nash",
      "lastMessage": "Are you there?",
      "iconPath": HelperFunction.userImage5,
      "time": "Dec 9",
      "unread": 1,
      "archived": false,
    },
    {
      "id": "5",
      "name": "Trot",
      "lastMessage": "I am fine!",
      "iconPath": HelperFunction.userImage6,
      "time": "Jan 2",
      "unread": 7,
      "archived": false,
    },
  ].obs;

  final TextEditingController searchController = TextEditingController();

  final RxString searchQuery = ''.obs;

  final RxInt selectedBottomIndex = 0.obs;

  List<Map<String, dynamic>> get filteredChats {
    final q = searchQuery.value.trim().toLowerCase();
    final list = chats.where((c) => c['archived'] == false).toList();
    if (q.isEmpty) return list;
    return list.where((c) {
      final name = (c['name'] ?? '').toString().toLowerCase();
      final last = (c['lastMessage'] ?? '').toString().toLowerCase();
      return name.contains(q) || last.contains(q);
    }).toList();
  }

  List<Map<String, dynamic>> get archivedChats => chats.where((c) => c['archived'] == true).toList();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void goToChatsRoomScreen(String username, {String? id}) {
    Get.toNamed(
      AppRoutes.chatsRoomScreen,
      arguments: {
        "username": username,
        "id": id,
      },
    );
  }

  void toggleArchive(String id) {
    final idx = chats.indexWhere((c) => c['id'] == id);
    if (idx == -1) return;
    final current = chats[idx];
    chats[idx] = {...current, "archived": !(current['archived'] as bool)};
  }

  void changeBottomNav(int idx) {
    selectedBottomIndex.value = idx;
  }

  void addNewContact(String iconPath) {
    final newItem = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "name": "New Contact ${chats.length + 1}",
      "lastMessage": "Hi there!",
      "iconPath": iconPath,
      "time": "Now",
      "unread": 0,
      "archived": false,
    };
    chats.insert(0, newItem);
  }

  Future<void> refreshChats() async {
    await Future.delayed(const Duration(milliseconds: 600));
    chats.refresh();
  }
}
