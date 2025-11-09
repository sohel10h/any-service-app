import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/data/model/network/create_service_details_model.dart';
import 'package:service_la/view/screens/create_service/controller/create_service_details_controller.dart';

class CreateServiceDetailsImageSlider extends GetWidget<CreateServiceDetailsController> {
  const CreateServiceDetailsImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 320.h,
            child: (controller.createServiceDetailsData.value.pictures?.isEmpty ?? true)
                ? Image.asset("assets/images/no_image_available.jpg")
                : PageView.builder(
                    itemCount: controller.createServiceDetailsData.value.pictures?.length ?? 0,
                    onPageChanged: (index) => controller.currentIndex.value = index,
                    itemBuilder: (context, index) {
                      final picture = controller.createServiceDetailsData.value.pictures?[index] ?? CreateServiceDetailsPicture();
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
                  color:
                      (controller.createServiceDetailsData.value.pictures?.isEmpty ?? true) ? AppColors.containerF4F4F4 : AppColors.white,
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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 36.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.containerFF6B4A,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  "25% OFF", //TODO: need to get this data from API
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                color: (controller.createServiceDetailsData.value.pictures?.isEmpty ?? true) ? AppColors.containerF4F4F4 : AppColors.white,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/svgs/heart_outline.svg",
                width: 14.w,
                height: 14.h,
                colorFilter: ColorFilter.mode(AppColors.text101828, BlendMode.srcIn),
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
                color: (controller.createServiceDetailsData.value.pictures?.isEmpty ?? true) ? AppColors.containerF4F4F4 : AppColors.white,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/svgs/share.svg",
                width: 14.w,
                height: 14.h,
              ),
            ),
          ),
          (controller.createServiceDetailsData.value.pictures?.isEmpty ?? true)
              ? const SizedBox.shrink()
              : Positioned(
                  right: 16.w,
                  bottom: 16.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: .6),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      "${controller.currentIndex.value + 1}/${controller.createServiceDetailsData.value.pictures?.length ?? 0}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
