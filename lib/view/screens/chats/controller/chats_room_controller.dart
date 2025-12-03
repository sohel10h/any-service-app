import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/data/repository/chats_repo.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/network/chat_messages_model.dart';
import 'package:service_la/data/model/network/common/chat_message_model.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class ChatsRoomController extends GetxController {
  String chatUsername = "";
  String chatUserId = "";
  String conversationId = "";
  bool isInsideChat = false;
  final chatInputController = TextEditingController();
  final RxBool isTyping = false.obs;
  final ChatsRepo _chatsRepo = ChatsRepo();
  RxList<ChatMessageModel> chatsMessages = <ChatMessageModel>[].obs;
  RxBool isLoadingChatsMessages = false.obs;
  RxBool isLoadingMoreChatsMessages = false.obs;
  int currentPageChatsMessages = 1;
  int totalPagesChatsMessages = 1;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _getChatsMessages(isRefresh: true);
    ever(AppDIController.message, (msg) {
      if (msg.message != null) {
        onWebsocketReceived(msg.message!);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    ever(chatsMessages, (_) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });
  }

  void goToProfileScreen(String? userId) {
    Get.delete<VendorProfileController>();
    Get.toNamed(
      AppRoutes.vendorProfileScreen,
      arguments: {
        "userId": userId,
      },
    );
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
      var response = isInsideChat
          ? await _chatsRepo.getChatsMessages(conversationId, queryParams: queryParams)
          : await _chatsRepo.getChatsMessagesUser(chatUserId, queryParams: queryParams);
      if (response is String) {
        log("ChatsMessages get failed from controller response: $response");
      } else {
        ChatMessagesModel chatMessage = response as ChatMessagesModel;
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
              () => isInsideChat
                  ? _chatsRepo.getChatsMessages(conversationId, queryParams: queryParams)
                  : _chatsRepo.getChatsMessagesUser(chatUserId, queryParams: queryParams),
            );
            if (retryResponse is ChatMessagesModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
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

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final now = DateTime.now().toUtc();
    final formatted = now.toIso8601String();
    final localMessage = ChatMessageModel(
      id: "temp_${now.microsecondsSinceEpoch}",
      content: text,
      senderId: AppDIController.loginUserId,
      createdAt: formatted,
      isLocal: true,
      isFailed: false,
    );
    chatsMessages.insert(0, localMessage);
    chatsMessages.refresh();
    _scrollToBottom();
    final payload = {
      ApiParams.type: WebsocketPayloadType.message.name,
      ApiParams.userId: chatUserId,
      ApiParams.content: text,
    };
    try {
      await AppDIController.sendWebsocketsMessageData(payload);
    } catch (e) {
      markMessageAsFailed(localMessage.id ?? "");
    }
  }

  void onWebsocketReceived(ChatMessageModel msg) {
    final idx = chatsMessages.indexWhere((m) => m.isLocal == true);
    if (idx != -1) {
      chatsMessages.removeAt(idx);
      chatsMessages.insert(
        idx,
        msg
          ..isLocal = false
          ..isFailed = false,
      );
    } else {
      chatsMessages.insert(0, msg);
    }
    chatsMessages.refresh();
  }

  void markMessageAsFailed(String tempId) {
    final idx = chatsMessages.indexWhere((m) => m.id == tempId);
    if (idx != -1) {
      chatsMessages[idx].isFailed = true;
      chatsMessages.refresh();
    }
  }

  void _getArguments() {
    if (Get.arguments != null) {
      chatUsername = Get.arguments["chatUsername"] ?? "User";
      conversationId = Get.arguments["conversationId"] ?? "";
      chatUserId = Get.arguments["chatUserId"] ?? "";
      isInsideChat = Get.arguments["isInsideChat"] ?? false;
      log(
        "ChatUserDetails: ChatUsername: $chatUsername "
        "- ConversationId: $conversationId "
        "- ChatUserId: $chatUserId "
        "- IsInsideChat: $isInsideChat",
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
    chatInputController.dispose();
  }
}
