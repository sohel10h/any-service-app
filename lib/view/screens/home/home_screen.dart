import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
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
                top: 50.h,
                left: 0,
                right: 0,
                child: _buildServiceSummaryCard(),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          _buildServiceRequestSection(context),
          SizedBox(height: 8.h),
          _buildCategorySection(),
        ],
      ),
    );
  }

  Widget _buildServiceRequestSection(BuildContext context) {
    return Hero(
      tag: "service_request_modal",
      createRectTween: (begin, end) => MaterialRectCenterArcTween(begin: begin, end: end),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => DialogHelper.showServiceRequestModal(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.borderD5D7DA),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.borderD5D7DA.withValues(alpha: 0.7),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12.sp),
                child: Column(
                  children: [
                    IgnorePointer(
                      child: CustomTextField(
                        controller: controller.serviceController,
                        focusNode: controller.serviceFocusNode,
                        hintText: "What service do you need today?",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.text6A7282,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        readonly: true,
                        fillColor: AppColors.containerF4F4F4,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Add details to get better quotes",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.text99A1AF,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Row(
                          children: [
                            SvgPicture.asset("assets/svgs/image.svg", width: 20.w),
                            SizedBox(width: 8.w),
                            SvgPicture.asset("assets/svgs/location.svg", width: 20.w),
                            SizedBox(width: 8.w),
                            SvgPicture.asset("assets/svgs/tag.svg", width: 20.w),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
          colors: [
            AppColors.container51A2FF,
            AppColors.container155DFC,
          ],
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Plumbing Services",
          iconPath: "assets/svgs/plumbing.svg",
          providers: 245,
          colors: [
            AppColors.containerC27AFF,
            AppColors.container9810FA,
          ],
          onTap: () {},
        ),
        CategoryItemModel(
          title: "At-Home Haircut",
          iconPath: "assets/svgs/haircut.svg",
          providers: 245,
          colors: [
            AppColors.containerFF8904,
            AppColors.containerF54900,
          ],
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Locksmith Services",
          iconPath: "assets/svgs/locksmith.svg",
          providers: 245,
          colors: [
            AppColors.containerFDC700,
            AppColors.containerD08700,
          ],
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Professional Chef",
          iconPath: "assets/svgs/chef.svg",
          providers: 245,
          colors: [
            AppColors.container05DF72,
            AppColors.container00A63E,
          ],
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Car Cleaning",
          iconPath: "assets/svgs/car_cleaning.svg",
          providers: 245,
          colors: [
            AppColors.container00D3F2,
            AppColors.container0092B8,
          ],
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Swimming Pool Cleaning",
          iconPath: "assets/svgs/swimming.svg",
          providers: 245,
          colors: [
            AppColors.containerFB64B6,
            AppColors.containerE60076,
          ],
          onTap: () {},
        ),
        CategoryItemModel(
          title: "Electricity Services",
          iconPath: "assets/svgs/settings_services.svg",
          providers: 245,
          colors: [
            AppColors.containerFF6467,
            AppColors.containerE7000B,
          ],
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 80.h,
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
            onChanged: (email) => controller.formKey.currentState?.validate(),
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
      _ServiceItem(title: "ServicePay", subtitle: "0.3% cashback"),
      _ServiceItem(title: "Check in", subtitle: "0.3% cashback"),
      _ServiceItem(title: "43", subtitle: "My vouchers"),
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
