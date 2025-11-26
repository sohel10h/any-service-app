import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';

class ChatsTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String iconPath;
  final String time;
  final int unread;
  final VoidCallback onTap;

  const ChatsTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.iconPath,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 10.w,
        right: 12.w,
      ),
      onTap: onTap,
      leading: NetworkImageLoader(
        iconPath,
        height: 48.w,
        width: 48.w,
        radius: 30.r,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.text101828,
          fontWeight: FontWeight.w600,
        ),
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
              color: AppColors.text6A7282,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (unread > 0)
            Container(
              decoration: BoxDecoration(
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
            )
        ],
      ),
    );
  }
}
