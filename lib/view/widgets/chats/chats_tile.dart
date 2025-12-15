import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/chats/controller/chats_list_controller.dart';

class ChatsTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String iconPath;
  final String time;
  final int unread;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isSelected;
  final bool isPinned;
  final String? userId;
  final ChatsListController controller;

  const ChatsTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.iconPath,
    required this.time,
    required this.unread,
    required this.onTap,
    required this.onLongPress,
    this.isSelected = false,
    this.isPinned = false,
    this.userId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        onTap: onTap,
        onLongPress: onLongPress,
        leading: Stack(
          fit: StackFit.loose,
          children: [
            GestureDetector(
              onTap: () => controller.goToProfileScreen(userId),
              child: NetworkImageLoader(
                iconPath,
                height: 36.w,
                width: 36.w,
                radius: 30.r,
                isUserImage: true,
              ),
            ),
            if (isSelected)
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: Container(
                  height: 12.w,
                  width: 12.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: 10.sp,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.text101828,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          lastMessage,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.text6A7282,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 10.sp,
                color: unread > 0 ? AppColors.primary : AppColors.text6A7282,
                fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPinned) SizedBox(height: 4.h),
                if (isPinned)
                  Padding(
                    padding: EdgeInsets.only(right: 4.w, top: unread > 0 ? 0.h : 4.h),
                    child: Icon(
                      Icons.push_pin,
                      size: 12.sp,
                      color: AppColors.text6A7282,
                    ),
                  ),
                if (unread > 0)
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Text(
                        unread.toString(),
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
