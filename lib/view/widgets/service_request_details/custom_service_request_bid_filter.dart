import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomServiceRequestBidFilter extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CustomServiceRequestBidFilter({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.h),
      child: Row(
        children: List.generate(
          filters.length,
          (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderE8E8E8,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (filters[index] == "Lowest Price")
                        SvgPicture.asset(
                          "assets/svgs/trending_down.svg",
                          width: 12.w,
                          height: 12.h,
                          colorFilter: ColorFilter.mode(
                            isSelected ? AppColors.white : AppColors.text364153,
                            BlendMode.srcIn,
                          ),
                        ),
                      if (filters[index] == "Top Rated")
                        SvgPicture.asset(
                          "assets/svgs/rating_outline.svg",
                          width: 12.w,
                          height: 12.h,
                          colorFilter: ColorFilter.mode(
                            isSelected ? AppColors.white : AppColors.text364153,
                            BlendMode.srcIn,
                          ),
                        ),
                      SizedBox(width: 8.w),
                      Text(
                        filters[index],
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isSelected ? AppColors.white : AppColors.text364153,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
