import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/data/repository/chats_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/data/model/network/chat_message_model.dart';

class ChatsRoomController extends GetxController {
  String chatUsername = "";
  String conversationId = "";
  String loginUserName = "";
  String loginUserId = "";
  final chatInputController = TextEditingController();
  final RxBool isTyping = false.obs;
  final ChatsRepo _chatsRepo = ChatsRepo();
  RxList<ChatMessage> chatsMessages = <ChatMessage>[].obs;
  RxBool isLoadingChatsMessages = false.obs;
  RxBool isLoadingMoreChatsMessages = false.obs;
  int currentPageChatsMessages = 1;
  int totalPagesChatsMessages = 1;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _getStorageValue();
    _getChatsMessages(isRefresh: true);
  }

  Future<void> loadNextPageChats() async {
    if (currentPageChatsMessages < totalPagesChatsMessages && !isLoadingMoreChatsMessages.value) {
      isLoadingMoreChatsMessages.value = true;
      currentPageChatsMessages++;
      await _getChatsMessages();
    }
  }

  Future<void> refreshChatsMessagesData({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    await _getChatsMessages(isRefresh: isRefresh, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getChatsMessages({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    if (isLoadingEmpty) totalPagesChatsMessages = 1;
    if (isRefresh) {
      currentPageChatsMessages = 1;
      chatsMessages.clear();
    }
    if (currentPageChatsMessages > totalPagesChatsMessages) return;
    if (isRefresh || isLoadingEmpty) {
      isLoadingChatsMessages.value = true;
    }
    try {
      Map<String, dynamic> queryParams = {
        'page': currentPageChatsMessages,
      };
      var response = await _chatsRepo.getChatsMessages(conversationId, queryParams: queryParams);
      if (response is String) {
        log("ChatsMessages get failed from controller response: $response");
      } else {
        ChatMessageModel chatMessage = response as ChatMessageModel;
        if (chatMessage.status == 200 || chatMessage.status == 201) {
          final data = chatMessage.chatMessageData?.chatMessages ?? [];
          if (isRefresh) {
            chatsMessages.assignAll(data);
          } else {
            chatsMessages.addAll(data);
          }
          currentPageChatsMessages = chatMessage.chatMessageData?.meta?.page ?? currentPageChatsMessages;
          totalPagesChatsMessages = chatMessage.chatMessageData?.meta?.totalPages ?? totalPagesChatsMessages;
        } else {
          if (chatMessage.status == 401 ||
              (chatMessage.errors != null &&
                  chatMessage.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _chatsRepo.getChatsMessages(conversationId, queryParams: queryParams),
            );
            if (retryResponse is ChatMessageModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              final data = retryResponse.chatMessageData?.chatMessages ?? [];
              if (isRefresh) {
                chatsMessages.assignAll(data);
              } else {
                chatsMessages.addAll(data);
              }
              currentPageChatsMessages = chatMessage.chatMessageData?.meta?.page ?? currentPageChatsMessages;
              totalPagesChatsMessages = chatMessage.chatMessageData?.meta?.totalPages ?? totalPagesChatsMessages;
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("ChatsMessages get failed from controller: ${chatMessage.status}");
          return;
        }
      }
    } catch (e) {
      log("ChatsMessages get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingChatsMessages.value = false;
      isLoadingMoreChatsMessages.value = false;
    }
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    chatsMessages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        senderId: loginUserId,
        senderName: loginUserId,
        content: chatInputController.text,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
  }

  void _getStorageValue() {
    loginUserName = StorageHelper.getValue(StorageHelper.username) ?? "";
    loginUserId = StorageHelper.getValue(StorageHelper.userId) ?? "";
  }

  void _getArguments() {
    if (Get.arguments != null) {
      chatUsername = Get.arguments["chatUsername"] ?? "User";
      conversationId = Get.arguments["conversationId"] ?? "";
    }
  }

  @override
  void onClose() {
    super.onClose();
    chatInputController.dispose();
  }
}
