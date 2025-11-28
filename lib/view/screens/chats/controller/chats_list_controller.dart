import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/data/repository/chats_repo.dart';
import 'package:service_la/data/model/network/chat_model.dart';
import 'package:service_la/services/api_service/api_service.dart';

class ChatsListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = "".obs;
  final RxInt selectedBottomIndex = 0.obs;
  var selectedChats = <String>[].obs;
  final ChatsRepo _chatsRepo = ChatsRepo();
  RxList<Conversation> conversations = <Conversation>[].obs;
  RxBool isLoadingChats = false.obs;
  RxBool isLoadingMoreChats = false.obs;
  int currentPageChats = 1;
  int totalPagesChats = 1;
  RxList<Conversation> archivedChats = <Conversation>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
    _getChats(isRefresh: true);
  }

  void goToChatsArchivedListScreen() => Get.toNamed(AppRoutes.chatsArchivedListScreen);

  void goToChatsRoomScreen(String username, {String? conversationId}) {
    Get.toNamed(
      AppRoutes.chatsRoomScreen,
      arguments: {
        "chatUsername": username,
        "conversationId": conversationId,
      },
    );
  }

  Future<void> loadNextPageChats() async {
    if (currentPageChats < totalPagesChats && !isLoadingMoreChats.value) {
      isLoadingMoreChats.value = true;
      currentPageChats++;
      await _getChats();
    }
  }

  Future<void> refreshChatsData({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    await _getChats(isRefresh: isRefresh, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getChats({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    if (isLoadingEmpty) totalPagesChats = 1;
    if (isRefresh) {
      currentPageChats = 1;
      conversations.clear();
    }
    if (currentPageChats > totalPagesChats) return;
    if (isRefresh || isLoadingEmpty) {
      isLoadingChats.value = true;
    }
    try {
      Map<String, dynamic> queryParams = {
        'page': currentPageChats,
      };
      var response = await _chatsRepo.getChats(queryParams: queryParams);
      if (response is String) {
        log("Chats get failed from controller response: $response");
      } else {
        ChatModel chat = response as ChatModel;
        if (chat.status == 200 || chat.status == 201) {
          final data = chat.chatData?.conversations ?? [];
          if (isRefresh) {
            conversations.assignAll(data);
          } else {
            conversations.addAll(data);
          }
          currentPageChats = chat.chatData?.meta?.page ?? currentPageChats;
          totalPagesChats = chat.chatData?.meta?.totalPages ?? totalPagesChats;
        } else {
          if (chat.status == 401 ||
              (chat.errors != null &&
                  chat.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _chatsRepo.getChats(queryParams: queryParams),
            );
            if (retryResponse is ChatModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              final data = retryResponse.chatData?.conversations ?? [];
              if (isRefresh) {
                conversations.assignAll(data);
              } else {
                conversations.addAll(data);
              }
              currentPageChats = chat.chatData?.meta?.page ?? currentPageChats;
              totalPagesChats = chat.chatData?.meta?.totalPages ?? totalPagesChats;
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("Chats get failed from controller: ${chat.status}");
          return;
        }
      }
    } catch (e) {
      log("Chats get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingChats.value = false;
      isLoadingMoreChats.value = false;
    }
  }

  RxBool get isSelectedPinned => RxBool(
        selectedChats.any((id) {
          final chat = conversations.firstWhere(
            (c) => c.id == id,
          );
          return (chat.id?.isNotEmpty ?? false) && chat.pinned == true;
        }),
      );

  RxBool get isSelectedArchived => RxBool(
        selectedChats.any((id) {
          final chat = conversations.firstWhere(
            (c) => c.id == id,
          );
          return (chat.id?.isNotEmpty ?? false) && chat.archived == true;
        }),
      );

  void togglePin(List<String> ids) {
    if (ids.isEmpty) return;
    for (var id in ids) {
      final idx = conversations.indexWhere((c) => c.id == id);
      if (idx == -1) continue;
      final current = conversations[idx];
      conversations[idx].pinned = !(current.pinned ?? false);
    }
    conversations.sort((a, b) {
      final aPinned = a.pinned == true;
      final bPinned = b.pinned == true;
      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;
      return 0;
    });
  }

  void deleteArchivedChats(List<String> ids) {
    if (ids.isEmpty) return;
    archivedChats.removeWhere((c) => ids.contains(c.id));
  }

  void deleteChats(List<String> ids) {
    if (ids.isEmpty) return;
    conversations.removeWhere((c) => ids.contains(c.id));
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

  List<Conversation> get filteredChats {
    conversations.any((c) => c.archived = false);
    final q = searchQuery.value.trim().toLowerCase();
    final list = conversations.where((c) => c.archived == false).toList();
    if (q.isEmpty) return list;
    return list.where((c) {
      final name = (c.lastMessage?.senderName ?? '').toString().toLowerCase();
      final last = (c.lastMessage?.content ?? '').toString().toLowerCase();
      return name.contains(q) || last.contains(q);
    }).toList();
  }

  void toggleArchive(List<String> ids) {
    if (ids.isEmpty) return;
    for (var id in ids) {
      final idx = conversations.indexWhere((c) => c.id == id);
      if (idx == -1) return;
      final current = conversations[idx];
      final isArchived = !(current.archived ?? false);
      conversations[idx].archived = isArchived;
    }
    archivedChats.assignAll(conversations.where((c) => c.archived == true));
  }

  void changeBottomNav(int idx) {
    selectedBottomIndex.value = idx;
  }

  void addNewContact(String iconPath) {
    final newItem = Conversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pinned: false,
      archived: false,
      lastMessage: LastMessage(
        id: "${DateTime.now().millisecondsSinceEpoch.toString()}_last_message",
        senderId: "${DateTime.now().millisecondsSinceEpoch.toString()}_sender_id",
        senderName: "Test User",
        content: "Hi, how are you?",
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    conversations.insert(0, newItem);
    conversations.sort((a, b) {
      final aPinned = a.pinned == true;
      final bPinned = b.pinned == true;
      if (aPinned && !bPinned) return -1;
      if (!aPinned && bPinned) return 1;
      return 0;
    });
  }

  Future<void> refreshChats() async {
    await Future.delayed(const Duration(milliseconds: 600));
    conversations.refresh();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
