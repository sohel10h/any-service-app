import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/screens/service_category_screen/controller/service_category_controller.dart';
import 'package:service_la/view/widgets/service_category/service_category_best_selling_services_card_item.dart';
import 'package:service_la/view/widgets/service_category/service_category_best_selling_services_item_shimmer.dart';

class ServiceCategoryBestSellingServicesSection extends StatelessWidget {
  final ServiceCategoryController controller;

  const ServiceCategoryBestSellingServicesSection({super.key, required this.controller});

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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Best Selling Services",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.text101828,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Most requested this week",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.text6A7282,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Obx(
      () {
        final isLoading = controller.isLoadingCategoryBestSellersServices.value;
        final categoryBestSellersServices = controller.categoryBestSellersServices;
        final height = 210.h;
        if (isLoading) {
          return SizedBox(
            height: height,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(12.sp),
              itemCount: 5,
              itemBuilder: (context, index) {
                return const ServiceCategoryBestSellingServicesItemShimmer();
              },
            ),
          );
        }
        if (categoryBestSellersServices.isEmpty) {
          return SizedBox(
            height: height,
            child: Padding(
              padding: EdgeInsets.all(12.sp),
              child: NoDataFound(
                message: "No best selling services are found!",
                textStyle: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.text6A7282,
                  fontWeight: FontWeight.w400,
                ),
                isRefresh: true,
                iconSize: 14.sp,
                onPressed: () => controller.refreshCategoryBestSellersServices(),
              ),
            ),
          );
        }
        return SizedBox(
          height: height,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(12.sp),
            itemCount: categoryBestSellersServices.length,
            itemBuilder: (context, index) {
              final categoryBestSellersService = categoryBestSellersServices[index];
              return ServiceCategoryBestSellingServicesCardItem(
                onTap: () => controller.goToCreateServiceDetailsScreen(categoryBestSellersService.id ?? ""),
                categoryBestSellersService: categoryBestSellersService,
              );
            },
          ),
        );
      },
    );
  }
}
