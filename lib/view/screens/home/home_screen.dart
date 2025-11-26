import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/home/category_section.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/widgets/home/cleaning_service_section.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';
import 'package:service_la/view/widgets/home/best_selling_services_section.dart';

class HomeScreen extends GetWidget<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(bottom: 100.h),
        children: [
          Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.none,
            children: [
              _buildTopHeader(),
              Positioned(
                top: 75.h,
                left: 0,
                right: 0,
                child: _buildServiceSummaryCard(),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          BestSellingServicesSection(controller: controller),
          SizedBox(height: 8.h),
          _buildCategorySection(),
          SizedBox(height: 8.h),
          CleaningServiceSection(controller: controller),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return CategorySection(
      title: "Categories",
      onShowAll: controller.goToCategoryScreen,
      controller: controller,
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 105.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            height: 35.h,
            controller: controller.searchController,
            focusNode: controller.searchFocusNode,
            hintText: "Search services...",
            labelStyle: TextStyle(
              fontSize: 12.sp,
              color: AppColors.text414651,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: AppColors.text757575,
              fontWeight: FontWeight.w400,
            ),
            prefixIconPath: "assets/svgs/search.svg",
            textInputAction: TextInputAction.search,
            onChanged: (searchServices) => controller.formKey.currentState?.validate(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(color: AppColors.borderE3E7EC),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        SvgPicture.asset(
          "assets/svgs/notification_outline.svg",
          width: 24.w,
          height: 24.h,
          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
        SizedBox(width: 16.w),
        SvgPicture.asset(
          "assets/svgs/message.svg",
          width: 24.w,
          height: 24.h,
          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ],
    );
  }

  Widget _buildServiceSummaryCard() {
    final items = [
      _ServiceItem(title: "1000+", subtitle: "Service Providers"),
      _ServiceItem(title: "5000+", subtitle: "Happy Customers"),
      _ServiceItem(title: "100+", subtitle: "5-star reviews"),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderD5D7DA),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildServiceItem(items[0]),
            SizedBox(
              height: 20.h,
              child: VerticalDivider(color: AppColors.black.withValues(alpha: .2)),
            ),
            _buildServiceItem(items[1]),
            SizedBox(
              height: 20.h,
              child: VerticalDivider(color: AppColors.black.withValues(alpha: .2)),
            ),
            _buildServiceItem(items[2]),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(_ServiceItem item) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            item.subtitle,
            style: TextStyle(
              fontSize: 9.sp,
              color: AppColors.black.withValues(alpha: .6),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final String title;
  final String subtitle;

  _ServiceItem({required this.title, required this.subtitle});
}
