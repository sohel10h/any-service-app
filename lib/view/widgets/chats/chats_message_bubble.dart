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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: EdgeInsets.all(12.sp),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    messageData.content ?? "",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    softWrap: true,
                  ),
                ),
                if (isFailed)
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Icon(Icons.error, color: AppColors.red, size: 14.sp),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              formatChatTimestamp(DateTime.tryParse(messageData.createdAt ?? "")),
              style: TextStyle(
                fontSize: 10.sp,
                color: textColor.withValues(alpha: isMe ? 0.7 : 0.3),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
