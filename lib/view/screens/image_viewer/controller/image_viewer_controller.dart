import 'package:get/get.dart';
import 'package:flutter/animation.dart';

class ImageViewerController extends GetxController with GetTickerProviderStateMixin {
  String imageUrl = "";
  late AnimationController animationController;
  late Animation<double> scaleAnim;

  @override
  void onInit() {
    _getArguments();
    _initAnimations();
    super.onInit();
  }

  void _initAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    scaleAnim = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    animationController.forward();
  }

  void close() async {
    await animationController.reverse();
    Get.back();
  }

  void _getArguments() {
    if (Get.arguments != null) {
      imageUrl = Get.arguments["imageUrl"] ?? "";
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
