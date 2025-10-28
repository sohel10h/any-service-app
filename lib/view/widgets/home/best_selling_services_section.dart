import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';
import 'package:service_la/view/widgets/home/best_selling_services_card_item.dart';

class BestSellingServicesSection extends StatelessWidget {
  final HomeController controller;

  const BestSellingServicesSection({super.key, required this.controller});

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
                    fontSize: 17.sp,
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
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset(
                  "assets/svgs/arrow_right_small.svg",
                  width: 16.w,
                  height: 16.h,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return SizedBox(
      height: 210.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        itemCount: controller.bestSellingServices.length,
        itemBuilder: (context, index) {
          return BestSellingServicesCardItem(service: controller.bestSellingServices[index]);
        },
      ),
    );
  }
}
