import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/network/common/picture_model.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class ServiceRequestDetailsImageSlider extends GetWidget<ServiceRequestDetailsController> {
  const ServiceRequestDetailsImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final serviceDetails = controller.serviceDetailsData.value;
      return Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 320.h,
            child: (serviceDetails.pictures?.isEmpty ?? true)
                ? Image.asset("assets/images/no_image_available.jpg")
                : PageView.builder(
                    itemCount: serviceDetails.pictures?.length ?? 0,
                    onPageChanged: (index) => controller.currentImageSliderIndex.value = index + 1,
                    itemBuilder: (context, index) {
                      final picture = serviceDetails.pictures?[index] ?? PictureModel();
                      return NetworkImageLoader(
                        picture.virtualPath ?? "",
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(0.r),
                      );
                    },
                  ),
          ),
          Positioned(
            top: 36.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 31.w,
                height: 31.w,
                padding: EdgeInsets.all(4.sp),
                decoration: BoxDecoration(
                  color: (serviceDetails.pictures?.isEmpty ?? true) ? AppColors.containerF4F4F4 : AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/svgs/arrow_left.svg",
                  width: 17.w,
                  height: 17.h,
                ),
              ),
            ),
          ),
          Positioned(
            top: 36.h,
            right: 56.w,
            child: Container(
              width: 31.w,
              height: 31.w,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: (serviceDetails.pictures?.isEmpty ?? true) ? AppColors.containerF4F4F4 : AppColors.white,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/svgs/share.svg",
                width: 14.w,
                height: 14.h,
              ),
            ),
          ),
          Positioned(
            top: 36.h,
            right: 16.w,
            child: Container(
              width: 31.w,
              height: 31.w,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: (serviceDetails.pictures?.isEmpty ?? true) ? AppColors.containerF4F4F4 : AppColors.white,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/svgs/more_vertical.svg",
                width: 14.w,
                height: 14.h,
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            bottom: 16.h,
            child: SvgPicture.asset(
              "assets/svgs/verified_provider.svg",
              width: 60.w,
              height: 67.h,
            ),
          ),
          (serviceDetails.pictures?.isEmpty ?? true)
              ? const SizedBox.shrink()
              : Positioned(
                  right: 16.w,
                  bottom: 16.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: .6),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      "${controller.currentImageSliderIndex.value}/${serviceDetails.pictures?.length ?? 0}",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
        ],
      );
    });
  }
}
