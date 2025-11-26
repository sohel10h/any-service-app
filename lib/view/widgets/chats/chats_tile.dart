import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final VoidCallback onTap;

  const ChatsTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 25.r,
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.person, color: AppColors.white),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
          if (unread > 0)
            Container(
              margin: EdgeInsets.only(top: 4.h),
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                unread.toString(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12.sp,
                ),
              ),
            )
        ],
      ),
    );
  }
}
