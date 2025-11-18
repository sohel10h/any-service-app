import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_item.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileServices extends GetWidget<VendorProfileController> {
  const VendorProfileServices({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Services",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.text101828,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton.icon(
                  onPressed: controller.goToCreateServiceScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.container155DFC,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/add_small.svg",
                        width: 14.w,
                        height: 14.h,
                        colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Create Service",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Obx(() {
              final services = controller.serviceMeDataList;
              if (controller.isLoadingServices.value) {
                return SizedBox(
                  height: Get.height / 1.3,
                  child: const CustomProgressBar(),
                );
              }
              if (services.isEmpty) {
                return SizedBox(
                  height: Get.height / 1.3,
                  child: NoDataFound(
                    message: "No services found!",
                    isRefresh: true,
                    onPressed: controller.refreshAdminServices,
                  ),
                );
              }

              return Column(
                children: services.map((service) => VendorProfileServiceItem(service: service, controller: controller)).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
