import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/home/best_selling_services_card_item.dart';
import 'package:service_la/view/widgets/home/best_selling_services_item_shimmer.dart';
import 'package:service_la/view/screens/best_selling_services/controller/best_selling_services_controller.dart';

class BestSellingServicesScreen extends GetWidget<BestSellingServicesController> {
  const BestSellingServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Best Selling Services"),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: controller.refreshBestSellingServices,
        child: Obx(() {
          final isLoading = controller.isLoadingBestSellingServices.value;
          final bestSellingServices = controller.bestSellingServices;
          if (isLoading) {
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.88,
              ),
              itemCount: 10,
              itemBuilder: (_, __) => const BestSellingServicesItemShimmer(),
            );
          }
          if (bestSellingServices.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(12.sp),
              child: NoDataFound(
                message: "No best selling services are found!",
                isRefresh: true,
                onPressed: controller.refreshBestSellingServices,
              ),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.88,
            ),
            itemCount: bestSellingServices.length,
            itemBuilder: (context, index) {
              final bestSellingService = bestSellingServices[index];
              return BestSellingServicesCardItem(
                onTap: () => controller.goToCreateServiceDetailsScreen(bestSellingService.id ?? ""),
                bestSellingService: bestSellingService,
              );
            },
          );
        }),
      ),
    );
  }
}
