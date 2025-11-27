import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/helper_function.dart';

class ChatsListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<Map<String, dynamic>> chats = <Map<String, dynamic>>[
    {
      "id": "1",
      "name": "Jack",
      "lastMessage": "Hello, how are you?",
      "iconPath": HelperFunction.userImage1,
      "time": "10:24 AM",
      "unread": 2,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "2",
      "name": "Dan",
      "lastMessage": "Thanks!",
      "iconPath": HelperFunction.userImage2,
      "time": "Yesterday",
      "unread": 0,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "3",
      "name": "Archived User",
      "lastMessage": "Archived message",
      "iconPath": HelperFunction.userImage3,
      "time": "Nov 20",
      "unread": 0,
      "archived": true,
      "pinned": false,
    },
    {
      "id": "4",
      "name": "Mike",
      "lastMessage": "Nice to meet you!, what are you doing now?",
      "iconPath": HelperFunction.userImage4,
      "time": "Sept 11",
      "unread": 5,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "5",
      "name": "Nash",
      "lastMessage": "Are you there?",
      "iconPath": HelperFunction.userImage5,
      "time": "Dec 9",
      "unread": 1,
      "archived": true,
      "pinned": false,
    },
    {
      "id": "6",
      "name": "Trot",
      "lastMessage": "I am fine!",
      "iconPath": HelperFunction.userImage6,
      "time": "Jan 2",
      "unread": 7,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "7",
      "name": "Moris",
      "lastMessage": "OK, I am asking now",
      "iconPath": HelperFunction.userImage7,
      "time": "Mar 29",
      "unread": 1,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "8",
      "name": "Kelvin",
      "lastMessage": "No, he didn't replied yet, do you need anything now?",
      "iconPath": HelperFunction.userImage8,
      "time": "Feb 13",
      "unread": 0,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "9",
      "name": "Becker",
      "lastMessage": "Tomorrow is the last day of the selection, please come first in the morning in the Anfield",
      "iconPath": HelperFunction.userImage9,
      "time": "Apr 9",
      "unread": 3,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "10",
      "name": "Luke",
      "lastMessage": "Tomorrow is the last day of the selection, please come first in the morning in the Anfield",
      "iconPath": HelperFunction.userImage10,
      "time": "Apr 9",
      "unread": 8,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "11",
      "name": "Rossie",
      "lastMessage": "Dan is with us right now, you can go there alone, thank you!",
      "iconPath": HelperFunction.userImage11,
      "time": "Jul 7",
      "unread": 2,
      "archived": false,
      "pinned": false,
    },
    {
      "id": "12",
      "name": "Rossie",
      "lastMessage": "Sir, I am asking for the gravity system, I need to know it very urgently, could you please describe?",
      "iconPath": HelperFunction.userImage12,
      "time": "May 7",
      "unread": 3,
      "archived": true,
      "pinned": false,
    },
  ].obs;
  final RxString searchQuery = "".obs;
  final RxInt selectedBottomIndex = 0.obs;
  var selectedChats = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  RxBool get isSelectedPinned => RxBool(
        selectedChats.any((id) {
          final chat = chats.firstWhere(
            (c) => c['id'] == id,
            orElse: () => {},
          );
          return chat.isNotEmpty && chat['pinned'] == true;
        }),
      );

  RxBool get isSelectedArchived => RxBool(
        selectedChats.any((id) {
          final chat = chats.firstWhere(
            (c) => c['id'] == id,
            orElse: () => {},
          );
          return chat.isNotEmpty && chat['archived'] == true;
        }),
      );

  void togglePin(List<String> ids) {
    for (var id in ids) {
      final idx = chats.indexWhere((c) => c['id'] == id);
      if (idx == -1) continue;
      final current = chats[idx];
      chats[idx] = {...current, "pinned": !(current['pinned'] as bool)};
    }
    chats.sort((a, b) {
      final aPinned = a['pinned'] == true;
      final bPinned = b['pinned'] == true;
      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;
      return 0;
    });
  }

  void deleteChats(List<String> ids) {
    chats.removeWhere((c) => ids.contains(c['id']));
  }

  void toggleSelection(String chatId) {
    if (selectedChats.contains(chatId)) {
      selectedChats.remove(chatId);
    } else {
      selectedChats.add(chatId);
    }
  }

  void clearSelection() {
    selectedChats.clear();
  }

  bool get isSelectionMode => selectedChats.isNotEmpty;

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

  RxList<Map<String, dynamic>> get archivedChats => chats.where((c) => c['archived'] == true).toList().obs;

  void goToChatsArchivedListScreen() => Get.toNamed(AppRoutes.chatsArchivedListScreen);

  void goToChatsRoomScreen(String username, {String? id}) {
    Get.toNamed(
      AppRoutes.chatsRoomScreen,
      arguments: {
        "username": username,
        "id": id,
      },
    );
  }

  void toggleArchive(List<String> ids) {
    for (var id in ids) {
      final idx = chats.indexWhere((c) => c['id'] == id);
      if (idx == -1) return;
      final current = chats[idx];
      chats[idx] = {...current, "archived": !(current['archived'] as bool)};
    }
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
      "pinned": false,
    };
    chats.insert(0, newItem);
    chats.sort((a, b) {
      final aPinned = a['pinned'] == true;
      final bPinned = b['pinned'] == true;
      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;
      return 0;
    });
  }

  Future<void> refreshChats() async {
    await Future.delayed(const Duration(milliseconds: 600));
    chats.refresh();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
