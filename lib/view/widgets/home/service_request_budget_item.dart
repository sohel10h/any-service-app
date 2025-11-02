import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';

class ServiceRequestBudgetItem extends GetWidget<HomeController> {
  const ServiceRequestBudgetItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: .15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/svgs/dollar.svg",
            colorFilter: ColorFilter.mode(AppColors.textCA3500, BlendMode.srcIn),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget Range",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text101828,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "৳${controller.minBudget.value} – ৳${controller.maxBudget.value}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textCA3500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _ActionButton(
            icon: "edit",
            onTap: () => controller.editBudgetRange(context),
          ),
          _ActionButton(
            icon: "close",
            onTap: () => controller.clearBudgetRange(),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      icon: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .1),
          shape: BoxShape.circle,
        ),
        child: Transform.scale(
          scale: .5,
          child: SvgPicture.asset(
            "assets/svgs/$icon.svg",
            colorFilter: ColorFilter.mode(AppColors.textCA3500, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
