import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/home/service_request_modal.dart';
import 'package:service_la/view/widgets/common/notification_bottom_sheet.dart';
import 'package:service_la/view/widgets/home/service_request_bottom_sheet.dart';
import 'package:service_la/view/widgets/home/service_request_discard_bottom_sheet.dart';
import 'package:service_la/view/widgets/home/service_request_budget_range_bottom_sheet.dart';

class DialogHelper {
  static void showServiceRequestModal(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        opaque: false,
        pageBuilder: (_, __, ___) => const ServiceRequestModal(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: child,
          );
        },
      ),
    );
  }

  static void showBottomSheet(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 50));
    await Get.bottomSheet(
      const ServiceRequestBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static void showDiscardWarning(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 50));
    Get.bottomSheet(
      const ServiceRequestDiscardBottomSheet(),
      isDismissible: false,
      backgroundColor: Colors.transparent,
    );
  }

  static void showBudgetRangeSheet(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 50));
    Get.bottomSheet(
      const ServiceRequestBudgetRangeBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static void showNotificationBottomSheet(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onPressed,
    String? actionTitle,
    VoidCallback? onClosed,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));
    Get.bottomSheet(
      NotificationBottomSheet(title: title, message: message, onPressed: onPressed, actionTitle: actionTitle),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    ).whenComplete(() {
      if (onClosed != null) onClosed();
    });
  }
}
