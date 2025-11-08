import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/create_service/controller/create_service_details_controller.dart';

class CreateServiceDetailsProviderProfileSection extends GetWidget<CreateServiceDetailsController> {
  const CreateServiceDetailsProviderProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Service Provider",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.text101828,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.containerF9FAFB,
              gradient: LinearGradient(
                colors: [
                  AppColors.containerF9FAFB,
                  AppColors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.containerF3F4F6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        NetworkImageLoader(
                          HelperFunction.userImage2, //TODO: need to get this data from API
                          width: 49.w,
                          height: 49.w,
                          borderRadius: BorderRadius.circular(60.r),
                        ),
                        Positioned(
                          right: -4,
                          bottom: -2,
                          child: Container(
                            width: 17.w,
                            height: 17.w,
                            decoration: BoxDecoration(
                              color: AppColors.container155DFC,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.white, width: 2),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: SvgPicture.asset(
                                "assets/svgs/verified_outline.svg",
                                width: 10.w,
                                height: 10.h,
                                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CoolAir Experts", //TODO: need to get this data from API
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.text101828,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/rating.svg",
                                width: 12.w,
                                height: 12.h,
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
                                        text: "${controller.serviceDetailsData.value.user?.rating ?? "0"}",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.text101828,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(text: " "),
                                      TextSpan(
                                        text: "(${controller.serviceDetailsData.value.user?.totalReview ?? "0"})",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: AppColors.text6A7282,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                width: 3.5.w,
                                height: 3.5.h,
                                decoration: BoxDecoration(
                                  color: AppColors.containerD1D5DC,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Member since 2019", //TODO: need to get this data from API
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.text6A7282,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Licensed and insured AC specialists with 15+ years of experience.", //TODO: need to get this data from API
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.text4A5565,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: _infoBox("Response Rate", "98%"), //TODO: need to get this data from API
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _infoBox("Response Time", "< 2 hours"), //TODO: need to get this data from API
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: AppColors.primary, width: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svgs/message_outline.svg",
                              width: 14.w,
                              height: 14.h,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Message",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: AppColors.containerD1D5DC, width: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: SvgPicture.asset(
                        "assets/svgs/phone_outline.svg",
                        width: 15.w,
                        height: 15.h,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Divider(color: AppColors.containerF3F4F6),
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _infoBox(String title, String value) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.containerF3F4F6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.text4A5565,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: value.contains("%") ? AppColors.text00A63E : AppColors.container155DFC,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
