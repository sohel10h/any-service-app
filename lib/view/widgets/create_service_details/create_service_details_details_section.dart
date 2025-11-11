import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/network/create_service_details_model.dart';
import 'package:service_la/view/screens/create_service/controller/create_service_details_controller.dart';
import 'package:service_la/view/widgets/create_service_details/create_service_details_service_info_section.dart';

class CreateServiceDetailsDetailsSection extends GetWidget<CreateServiceDetailsController> {
  const CreateServiceDetailsDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            SizedBox(
              height: 30.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                itemCount: controller.createServiceDetailsData.value.categories?.length ?? 0,
                itemBuilder: (context, index) {
                  final category = controller.createServiceDetailsData.value.categories?[index] ?? CreateServiceDetailsCategory();
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: AppColors.containerEFF6FF,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: AppColors.container2B7FFF,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            category.name ?? "",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.text1447E6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                controller.createServiceDetailsData.value.name?.capitalizeFirst ?? "",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.text101828,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/svgs/rating.svg",
                    width: 14.w,
                    height: 14.h,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    flex: 1,
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${controller.createServiceDetailsData.value.rating ?? "0"}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.text101828,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: " "),
                          TextSpan(
                            text: "(${controller.createServiceDetailsData.value.totalReview ?? "0"} reviews)",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.text6A7282,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Container(
                    width: 3.5.w,
                    height: 3.5.h,
                    decoration: BoxDecoration(
                      color: AppColors.containerD1D5DC,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${controller.createServiceDetailsData.value.serviceCompletedCount ?? "0"} jobs completed",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.text4A5565,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "\$${(controller.createServiceDetailsData.value.price as double?)?.toStringAsFixed(2) ?? "0"}",
                    style: TextStyle(
                      fontSize: 26.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "\$${(controller.createServiceDetailsData.value.price as double?)?.toStringAsFixed(2) ?? "0"}",
                    //TODO: need to get this data from API
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.text99A1AF,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.text99A1AF,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "starting price",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.text4A5565,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Price range: \$${controller.createServiceDetailsData.value.priceStart ?? "0"}"
                " - \$${controller.createServiceDetailsData.value.priceEnd ?? "0"}",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.text6A7282,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Divider(color: AppColors.containerF3F4F6),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CreateServiceDetailsServiceInfoSection(),
            ),
            SizedBox(height: 12.h),
            Divider(color: AppColors.containerF3F4F6),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Description",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.text101828,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                controller.createServiceDetailsData.value.description ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.text4A5565,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Divider(color: AppColors.containerF3F4F6),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
