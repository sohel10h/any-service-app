import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/local/category_model.dart';
import 'package:service_la/view/widgets/home/category_section.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';

class HomeScreen extends GetWidget<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HelperFunction.changeStatusBarColor();
    return Scaffold(
      backgroundColor: AppColors.backgroundD4F1F9.withValues(alpha: .2),
      body: ListView(
        children: [
          Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.none,
            children: [
              _buildTopHeader(),
              Positioned(
                top: 80.h,
                left: 0,
                right: 0,
                child: _buildServiceSummaryCard(),
              ),
            ],
          ),
          SizedBox(height: 56.h),
          _buildLiveBiddingArena(),
          SizedBox(height: 8.h),
          _buildCategorySection(),
        ],
      ),
    );
  }

  Widget _buildLiveBiddingArena() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 270.h,
          color: AppColors.primary,
          child: Stack(
            children: List.generate(7, (index) {
              final svgIndex = 7 - index;
              return Positioned(
                right: 0,
                bottom: 0,
                child: SvgPicture.asset(
                  "assets/svgs/container_shape_$svgIndex.svg",
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return CategorySection(
      title: "Categories",
      onShowAll: () => debugPrint("Show all clicked"),
      items: [
        CategoryItemModel(
          title: "Home cleaning",
          iconPath: "assets/svgs/home_cleaning.svg",
          providers: 245,
          color: AppColors.container4485FD,
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Plumbing Services",
          iconPath: "assets/svgs/plumbing.svg",
          providers: 245,
          color: AppColors.containerA584FF,
          onTap: () {},
        ),
        CategoryItemModel(
          title: "At-Home Haircut",
          iconPath: "assets/svgs/haircut.svg",
          providers: 245,
          color: AppColors.containerFF7854,
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Locksmith Services",
          iconPath: "assets/svgs/locksmith.svg",
          providers: 245,
          color: AppColors.containerFEA725,
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Professional Chef",
          iconPath: "assets/svgs/chef.svg",
          providers: 245,
          color: AppColors.container00CC6A,
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Car Cleaning",
          iconPath: "assets/svgs/car_cleaning.svg",
          providers: 245,
          color: AppColors.container00C9E4,
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Swimming Pool Cleaning",
          iconPath: "assets/svgs/swimming.svg",
          providers: 245,
          color: AppColors.containerFD44B3,
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Electricity Services",
          iconPath: "assets/svgs/electricity.svg",
          providers: 245,
          color: AppColors.containerFD4444,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 130.h,
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: CustomTextField(
              controller: controller.searchController,
              focusNode: controller.searchFocusNode,
              hintText: "Search services...",
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: AppColors.text757575,
                fontWeight: FontWeight.w400,
              ),
              prefixIconPath: "assets/svgs/search.svg",
              textInputAction: TextInputAction.search,
              onChanged: (email) => controller.formKey.currentState?.validate(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          height: 44.h,
          width: 44.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Transform.scale(
            scale: .5,
            child: SvgPicture.asset(
              "assets/svgs/message.svg",
              width: 18.w,
              height: 18.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSummaryCard() {
    final items = [
      _ServiceItem(title: "ServicePay", subtitle: "0.3% cashback"),
      _ServiceItem(title: "Check in", subtitle: "0.3% cashback"),
      _ServiceItem(title: "43", subtitle: "My vouchers"),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildServiceItem(items[0]),
            SizedBox(
              height: 50.h,
              child: VerticalDivider(color: AppColors.black.withValues(alpha: .2)),
            ),
            _buildServiceItem(items[1]),
            SizedBox(
              height: 50.h,
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
              fontSize: 14.sp,
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
              fontSize: 10.sp,
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
