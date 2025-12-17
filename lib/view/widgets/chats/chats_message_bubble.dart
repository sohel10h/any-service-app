import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/date_time/format_date.dart';
import 'package:service_la/data/model/network/common/chat_message_model.dart';

class ChatsMessageBubble extends StatelessWidget {
  final ChatMessageModel messageData;
  final String loginUserId;

  const ChatsMessageBubble({
    super.key,
    required this.messageData,
    required this.loginUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = messageData.senderId == loginUserId;
    final isFailed = messageData.isFailed ?? false;
    final isLocal = messageData.isLocal ?? false;
    final bgColor = isMe && (isLocal || isFailed)
        ? AppColors.primary.withValues(alpha: 0.5)
        : isMe
            ? AppColors.primary
            : AppColors.dividerE9EAEB.withValues(alpha: 0.4);
    final textColor = isMe ? AppColors.white : AppColors.black;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Get.width * 0.75),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
                bottomLeft: isMe ? Radius.circular(12.r) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12.r),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: isFailed ? 68.w : 56.w, bottom: 6.h),
                  child: Text(
                    messageData.content ?? "",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatChatTimestamp(DateTime.tryParse(messageData.createdAt ?? "")),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: textColor.withValues(alpha: isMe ? 0.7 : 0.4),
                        ),
                      ),
                      if (isFailed)
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Icon(Icons.error, size: 12.sp, color: AppColors.red),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
