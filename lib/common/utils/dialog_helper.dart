import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/home/service_request_modal.dart';

class DialogHelper {
  static void showServiceRequestModal(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.1),
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
}
