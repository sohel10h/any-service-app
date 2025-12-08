import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/image_viewer/controller/image_viewer_controller.dart';

class ImageViewerScreen extends GetView<ImageViewerController> {
  const ImageViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          controller.close();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black.withValues(alpha: 0.95),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: ScaleTransition(
                  scale: controller.scaleAnim,
                  child: Hero(
                    tag: controller.imageUrl,
                    child: PhotoView(
                      imageProvider: NetworkImage(controller.imageUrl),
                      minScale: PhotoViewComputedScale.contained * 1,
                      maxScale: PhotoViewComputedScale.covered * 3,
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: GestureDetector(
                  onTap: controller.close,
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 22.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
