import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/home/category_card_item.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/home/category_item_shimmer.dart';
import 'package:service_la/view/screens/category_screen/controller/category_controller.dart';

class CategoryScreen extends GetWidget<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Categories"),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: () => controller.refreshAllServiceCategories(isRefresh: true),
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
                  return CategoryCardItem(
                    onTap: () => controller.goToServiceCategoryScreen(serviceCategory.id ?? ""),
                    serviceCategory: serviceCategory,
                  );
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
    );
  }
}
