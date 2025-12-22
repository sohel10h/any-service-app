import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/network/common/service_model.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/data/model/network/best_selling_service_model.dart';

class ServiceCategoryBestSellingServicesCardItem extends StatelessWidget {
  final VoidCallback onTap;
  final ServiceModel bestSellingService;

  const ServiceCategoryBestSellingServicesCardItem({
    super.key,
    required this.onTap,
    required this.bestSellingService,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 180.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: .2),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  NetworkImageLoader(
                    bestSellingService.picture?.virtualPath ?? "",
                    height: 84.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.containerFB2C36, // TODO: need this field value from API
                            AppColors.containerFF6900, // TODO: need this field value from API
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svgs/star.svg",
                            width: 10.w,
                            height: 10.h,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Best", // TODO: need this field value from API
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: .95),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svgs/rating.svg",
                            width: 10.w,
                            height: 10.h,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${bestSellingService.rating?.toStringAsFixed(2) ?? 0}",
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.text101828,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8.w,
                    bottom: 8.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: .95),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "\$${bestSellingService.price?.toDouble().toStringAsFixed(2) ?? 0}",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8.w,
                    bottom: 8.h,
                    child: Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        color: AppColors.container00C950,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        "${bestSellingService.serviceCompletedCount ?? 0} Booked",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bestSellingService.name ?? "",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.text101828,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svgs/rating.svg",
                          width: 10.w,
                          height: 10.h,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            bestSellingService.description ?? "",
                            style: TextStyle(
                              fontSize: 9.sp,
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
