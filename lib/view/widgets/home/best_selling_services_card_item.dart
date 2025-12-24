import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_badge.dart';
import 'package:service_la/data/model/network/common/service_model.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';

class BestSellingServicesCardItem extends StatelessWidget {
  final VoidCallback onTap;
  final ServiceModel bestSellingService;

  const BestSellingServicesCardItem({
    super.key,
    required this.onTap,
    required this.bestSellingService,
  });

  String get priceText {
    final price = bestSellingService.price;
    final start = bestSellingService.priceStart;
    final end = bestSellingService.priceEnd;
    if (price != null && price != 0) {
      return '\$${price.toStringAsFixed(2)}';
    }
    if (start != null && start != 0 && end != null && end != 0) {
      return '\$${start.toStringAsFixed(2)} – \$${end.toStringAsFixed(2)}';
    }
    return '\$0';
  }

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
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: .08),
                blurRadius: 10,
                offset: const Offset(0, 4),
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
                    height: 50.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14.r),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: CustomBadge(
                      icon: "assets/svgs/star.svg",
                      text: "Best",
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.containerFB2C36,
                          AppColors.containerFF6900,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: CustomBadge(
                      icon: "assets/svgs/rating.svg",
                      text: bestSellingService.rating?.toStringAsFixed(1) ?? "0.0",
                      backgroundColor: AppColors.white,
                      textColor: AppColors.text101828,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bestSellingService.name ?? "",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text101828,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      bestSellingService.description ?? "",
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.text6A7282,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      priceText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.container00C950,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        "${bestSellingService.serviceCompletedCount ?? 0} Booked",
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          "Book Now",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
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
