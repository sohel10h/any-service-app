import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/common/utils/date_time/format_date.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/notification/controller/notifications_details_controller.dart';

class NotificationsDetailsScreen extends GetWidget<NotificationsDetailsController> {
  const NotificationsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notification = controller.notification;
    final NotificationType? typeEnum = HelperFunction.mapType(notification.type);
    final badgeColor = HelperFunction.badgeColor(typeEnum);
    final badgeText = HelperFunction.badgeText(typeEnum);
    return Scaffold(
      appBar: const CustomAppbar(title: "Notifications Details"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? "No Title",
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.text101828,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              formatTimeAgo(notification.createdOnUtc),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.text6A7282,
              ),
            ),
            SizedBox(height: 16.h),
            if (notification.pictureUrl != null && notification.pictureUrl!.isNotEmpty)
              Hero(
                tag: notification.pictureUrl ?? "",
                child: GestureDetector(
                  onTap: () => controller.goToImageViewerScreen(notification.pictureUrl ?? ""),
                  child: NetworkImageLoader(
                    notification.pictureUrl!,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            if (notification.pictureUrl != null && notification.pictureUrl!.isNotEmpty) SizedBox(height: 20.h),
            Text(
              notification.body ?? "No message available.",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text101828,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.h),
            if (notification.type != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: .05),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: badgeColor, width: 1),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
