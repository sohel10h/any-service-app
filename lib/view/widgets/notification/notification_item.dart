import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/date_time/format_date.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/data/model/network/common/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final bool isRead = notification.isRead ?? false;
    final NotificationType? typeEnum = _mapType(notification.type);
    final badgeColor = _badgeColor(typeEnum);
    final badgeText = _badgeText(typeEnum);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageLoader(
            notification.pictureUrl ?? "",
            width: 56.w,
            height: 56.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!isRead)
                      Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "New",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: .05),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: badgeColor),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 7.sp,
                          color: badgeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        formatTimeAgo(notification.createdOnUtc ?? ""),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.text6A7282,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (!isRead) SizedBox(height: 4.h),
                Text(
                  notification.title ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.text101828,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  notification.body ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text6A7282,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  NotificationType? _mapType(int? value) {
    if (value == null) return null;
    return NotificationType.values.firstWhere(
      (e) => e.typeValue == value,
      orElse: () => NotificationType.email,
    );
  }

  String _badgeText(NotificationType? type) {
    switch (type) {
      case NotificationType.email:
        return "EMAIL";
      case NotificationType.sms:
        return "SMS";
      case NotificationType.serviceRequest:
        return "SERVICE";
      case NotificationType.bid:
        return "BID";
      case NotificationType.vendorFound:
        return "FOUND";
      case NotificationType.vendorNotFound:
        return "NO VENDOR";
      default:
        return "INFO";
    }
  }

  Color _badgeColor(NotificationType? type) {
    switch (type) {
      case NotificationType.email:
        return Colors.blueAccent;
      case NotificationType.sms:
        return Colors.green;
      case NotificationType.serviceRequest:
        return Colors.orange;
      case NotificationType.bid:
        return Colors.purple;
      case NotificationType.vendorFound:
        return Colors.teal;
      case NotificationType.vendorNotFound:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
