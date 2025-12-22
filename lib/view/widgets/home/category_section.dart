import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/home/delayed_widget.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/home/category_card_item.dart';
import 'package:service_la/view/widgets/home/category_item_shimmer.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final VoidCallback onShowAll;
  final HomeController controller;

  const CategorySection({
    super.key,
    required this.title,
    required this.onShowAll,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 12.h),
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.text101828,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: onShowAll,
          child: Row(
            children: [
              Text(
                "View all",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SvgPicture.asset(
                "assets/svgs/arrow_right_small.svg",
                width: 14.w,
                height: 14.h,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return Obx(() {
      final isLoading = controller.isLoadingServiceCategories.value;
      final serviceCategories = controller.serviceCategories;
      if (isLoading) {
        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 12.h,
          ),
          itemBuilder: (context, index) {
            return const CategoryItemShimmer();
          },
        );
      }
      if (serviceCategories.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(12.sp),
          child: NoDataFound(
            message: "No categories are found!",
            textStyle: TextStyle(
              fontSize: 11.sp,
              color: AppColors.text6A7282,
              fontWeight: FontWeight.w400,
            ),
            isRefresh: true,
            iconSize: 14.sp,
            onPressed: () => controller.getAdminServiceCategories(),
          ),
        );
      }
      return GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: serviceCategories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 12.h,
        ),
        itemBuilder: (context, index) {
          final serviceCategory = serviceCategories[index];
          final isLeft = index % 2 == 0;
          final offsetX = isLeft ? -80.0 : 80.0;
          return DelayedWidget(
            delay: Duration(milliseconds: 120 * index),
            child: TweenAnimationBuilder<Offset>(
              tween: Tween(begin: Offset(offsetX, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutQuart,
              builder: (context, offset, child) {
                final opacity = 1 - (offset.dx.abs() / 80);
                return Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.translate(offset: offset, child: child),
                );
              },
              child: CategoryCardItem(
                onTap: () => controller.goToServiceCategoryScreen(serviceCategory.id ?? ""),
                serviceCategory: serviceCategory,
              ),
            ),
          );
        },
      );
    });
  }
}
