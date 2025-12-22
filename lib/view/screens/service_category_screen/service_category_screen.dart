import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/home/category_card_item.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/home/category_item_shimmer.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/service_category_screen/controller/service_category_controller.dart';
import 'package:service_la/view/widgets/service_category/service_category_best_selling_services_section.dart';

class ServiceCategoryScreen extends GetWidget<ServiceCategoryController> {
  const ServiceCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        backButtonPadding: 8.w,
        backgroundColor: AppColors.primary,
        backButtonBackgroundColor: AppColors.white,
        titleWidget: _buildTopHeader(),
        actions: _buildActions(),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: () => controller.refreshAllServiceCategories(isRefresh: true),
        child: Column(
          children: [
            ServiceCategoryBestSellingServicesSection(controller: controller),
            SizedBox(height: 16.h),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
                    controller.loadNextPageAllServiceCategories();
                  }
                  return false;
                },
                child: Obx(() {
                  final isLoading = controller.isLoadingServiceCategories.value;
                  final serviceCategories = controller.serviceCategories;
                  if (isLoading) {
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      itemCount: 10,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (_, __) => const CategoryItemShimmer(),
                    );
                  }
                  if (serviceCategories.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(12.sp),
                      child: NoDataFound(
                        message: "No categories are found!",
                        isRefresh: true,
                        onPressed: () => controller.refreshAllServiceCategories(isLoadingEmpty: true),
                      ),
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    itemCount: serviceCategories.length + (controller.isLoadingMoreServiceCategories.value ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      if (index < controller.serviceCategories.length) {
                        final serviceCategory = serviceCategories[index];
                        return CategoryCardItem(onTap: () {}, serviceCategory: serviceCategory);
                      }
                      return Obx(
                        () => controller.isLoadingMoreServiceCategories.value
                            ? Padding(
                                padding: EdgeInsets.all(16.sp),
                                child: const CustomProgressBar(),
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      GestureDetector(
        onTap: controller.goToNotificationsScreen,
        child: Obx(() {
          final unreadCount = AppDIController.unreadNotificationCount.value;
          final unread = (unreadCount ?? 0) > 99 ? "99+" : "${unreadCount ?? ""}";
          if (unread.isEmpty) {
            return SvgPicture.asset(
              "assets/svgs/notification_outline.svg",
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
            );
          }
          return Badge(
            label: Text(unread),
            child: SvgPicture.asset(
              "assets/svgs/notification_outline.svg",
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
            ),
          );
        }),
      ),
      SizedBox(width: 16.w),
      GestureDetector(
        onTap: controller.goToChatsListScreen,
        child: SvgPicture.asset(
          "assets/svgs/message.svg",
          width: 20.w,
          height: 20.h,
          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ),
      SizedBox(width: 16.w),
    ];
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: EdgeInsetsGeometry.only(right: 8.w),
      child: _buildSearchBar(),
    );
  }

  Widget _buildSearchBar() {
    return Hero(
      tag: "categorySearchBar",
      child: Material(
        color: Colors.transparent,
        child: CustomTextField(
          height: 35.h,
          controller: controller.searchController,
          focusNode: controller.searchFocusNode,
          readonly: true,
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
          onTap: () => controller.goToSearchScreen("categorySearchBar"),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.r),
            borderSide: BorderSide(color: AppColors.borderE3E7EC),
          ),
        ),
      ),
    );
  }
}
