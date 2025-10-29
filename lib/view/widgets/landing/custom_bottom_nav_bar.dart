import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/landing/bottom_nav_bar_notch_painter.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem("Home", "assets/svgs/home.svg"),
      _NavItem("Bidding", "assets/svgs/charity.svg"),
      _NavItem("Services", "assets/svgs/configuration.svg"),
      _NavItem("Profile", "assets/svgs/user.svg"),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomPaint(
        painter: BottomNavBarNotchPainter(color: AppColors.white),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(2, (index) {
                          final item = items[index];
                          final isSelected = currentIndex == index;
                          return Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: GestureDetector(
                              onTap: () => onTap(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [
                                            AppColors.containerFF8904,
                                            AppColors.containerF54900,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      item.iconPath,
                                      width: 18.w,
                                      height: 18.h,
                                      colorFilter: ColorFilter.mode(
                                        isSelected ? AppColors.white : AppColors.black,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      SizedBox(width: 4.w),
                                      Text(
                                        item.label,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(2, (i) {
                          final index = i + 2;
                          final item = items[index];
                          final isSelected = currentIndex == index;
                          return Padding(
                            padding: EdgeInsets.only(left: 6.w),
                            child: GestureDetector(
                              onTap: () => onTap(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [
                                            AppColors.containerFF8904,
                                            AppColors.containerF54900,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      item.iconPath,
                                      width: 18.w,
                                      height: 18.h,
                                      colorFilter: ColorFilter.mode(
                                        isSelected ? AppColors.white : AppColors.black,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      SizedBox(width: 4.w),
                                      Text(
                                        item.label,
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String iconPath;

  const _NavItem(this.label, this.iconPath);
}
