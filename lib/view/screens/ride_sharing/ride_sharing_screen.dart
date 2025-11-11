import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/home/custom_dropdown_chip.dart';
import 'package:service_la/view/screens/ride_sharing/controller/ride_sharing_controller.dart';

class RideSharingScreen extends GetWidget<RideSharingController> {
  const RideSharingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.orange),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 100.h),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.scaffoldKey.currentState?.openDrawer();
                      },
                      child: Icon(Icons.menu, size: 24.sp),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  height: 83.h,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.containerFF6D00,
                        AppColors.containerD56551,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Refer A Friend Today!",
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Enjoy \$5 OFF your next delivery! →",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.white.withValues(alpha: .9),
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "assets/images/container_box.png",
                        width: 49.w,
                        height: 75.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.borderE5E7EB),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.circle, size: 10.sp, color: AppColors.containerFF6900),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              "14 Lorong Limau",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: AppColors.text101828.withValues(alpha: .5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          CustomDropdownChip<String>(
                            width: Get.width / 4,
                            options: controller.timeOptions,
                            selectedValue: controller.selectedTime,
                            labelBuilder: (v) => v,
                            onChanged: (val) {
                              // handle change
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svgs/location_outline.svg",
                            width: 10.w,
                            height: 10.w,
                            colorFilter: ColorFilter.mode(AppColors.containerFF6900, BlendMode.srcIn),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Drop-off location",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.text101828.withValues(alpha: .5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "+ Add Stop",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.text4A5565,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Available vehicles",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.text101828,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),
                _vehiclesList(),
                SizedBox(height: 20.h),
                Center(
                  child: TextButton(
                    onPressed: controller.goToRideSharingMapScreen,
                    child: Text(
                      "See More",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.text6A7282,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehiclesList() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderE5E7EB),
      ),
      child: Column(
        children: [
          _vehicleItem("🏍", "Courier"),
          Divider(color: AppColors.containerF3F4F6),
          _vehicleItem("🚗", "Car"),
          Divider(color: AppColors.containerF3F4F6),
          _vehicleItem("🚙", "MPV (Weight<25KG x 2)"),
          Divider(color: AppColors.containerF3F4F6),
          _vehicleItem("🚚", "1.7M Van"),
          Divider(color: AppColors.containerF3F4F6),
          _vehicleItem("🚛", "2.4M Van"),
        ],
      ),
    );
  }

  Widget _vehicleItem(String emoji, String name) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 22.sp)),
          SizedBox(width: 12.w),
          Flexible(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.text101828,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
