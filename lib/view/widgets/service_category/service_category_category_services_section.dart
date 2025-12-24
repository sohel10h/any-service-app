import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/service_category/service_category_category_services_card_item.dart';
import 'package:service_la/view/screens/service_category_screen/controller/service_category_controller.dart';
import 'package:service_la/view/widgets/service_category/service_category_category_services_item_shimmer.dart';

class ServiceCategoryCategoryServicesSection extends StatelessWidget {
  final ServiceCategoryController controller;

  const ServiceCategoryCategoryServicesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        _buildHeader(),
        SizedBox(height: 4.h),
        _buildListView(),
      ],
    );
  }

  Widget _buildListView() {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
            controller.loadNextPageCategoryServices();
          }
          return false;
        },
        child: Obx(() {
          final isLoading = controller.isLoadingCategoryServices.value;
          final categoryServices = controller.categoryServices;
          final isLoadingMore = controller.isLoadingMoreCategoryServices.value;
          final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 0.61,
          );
          if (isLoading) {
            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(12.sp),
              gridDelegate: gridDelegate,
              itemCount: 10,
              itemBuilder: (_, __) => const ServiceCategoryCategoryServicesItemShimmer(),
            );
          }
          if (categoryServices.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(12.sp),
              child: NoDataFound(
                message: "No services are found!",
                isRefresh: true,
                onPressed: () => controller.refreshCategoryServices(isLoadingEmpty: true),
              ),
            );
          }
          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(12.sp),
            gridDelegate: gridDelegate,
            itemCount: categoryServices.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < categoryServices.length) {
                final categoryService = categoryServices[index];
                return ServiceCategoryCategoryServicesCardItem(
                  onTap: () => controller.goToCreateServiceDetailsScreen(categoryService.id ?? ""),
                  categoryService: categoryService,
                );
              }
              return isLoadingMore
                  ? Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: const CustomProgressBar(),
                    )
                  : const SizedBox.shrink();
            },
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category Services",
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.text101828,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Category wise services",
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.text6A7282,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
