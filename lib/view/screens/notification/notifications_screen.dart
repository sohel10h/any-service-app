import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/notification/notification_item.dart';
import 'package:service_la/view/widgets/notification/notification_item_shimmer.dart';
import 'package:service_la/view/screens/notification/controller/notifications_controller.dart';

class NotificationsScreen extends GetWidget<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white.withValues(alpha: .95),
      appBar: const CustomAppbar(title: "Notifications"),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: () => controller.refreshNotifications(isRefresh: true),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
              controller.loadNextPageNotifications();
            }
            return false;
          },
          child: Obx(() {
            final isLoading = controller.isLoadingNotifications.value;
            final notifications = controller.notifications;
            if (isLoading) {
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 2.h, bottom: 12.h),
                itemCount: 10,
                separatorBuilder: (_, __) => SizedBox(height: 2.h),
                itemBuilder: (_, __) => const NotificationItemShimmer(),
              );
            }
            if (notifications.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(12.sp),
                child: NoDataFound(
                  message: "No notifications are found!",
                  isRefresh: true,
                  onPressed: () => controller.refreshNotifications(isLoadingEmpty: true),
                ),
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 2.h, bottom: 12.h),
              itemCount: notifications.length + (controller.isLoadingMoreNotifications.value ? 1 : 0),
              separatorBuilder: (_, __) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                if (index < controller.notifications.length) {
                  final notification = notifications[index];
                  return NotificationItem(notification: notification);
                }
                return Obx(
                  () => controller.isLoadingMoreNotifications.value
                      ? Padding(
                          padding: EdgeInsets.all(16.sp),
                          child: const CustomProgressBar(),
                        )
                      : const SizedBox.shrink(),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
