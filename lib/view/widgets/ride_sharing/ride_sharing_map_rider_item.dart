import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideSharingMapRiderItem extends StatelessWidget {
  final Map<String, dynamic> rideOption;
  const RideSharingMapRiderItem({super.key, required this.rideOption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            buildHeader(rideOption),
            SizedBox(height: 14.h),
            buildPayment(rideOption),
            SizedBox(height: 14.h),
            buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(Map<String, dynamic> data) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            data["avatar"],
            width: 55.w,
            height: 55.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["plate"],
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                data["car"],
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
        Image.network(
          data["carImage"],
          width: 80.w,
          height: 45.h,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget buildPayment(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Image.network(
            data["paymentLogo"],
            width: 40.w,
            height: 30.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["paymentMethod"],
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Your Balance: ${data["balance"]}",
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            data["bookingText"],
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildConfirmButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32.r),
      ),
      alignment: Alignment.center,
      child: Text(
        "Confirm",
        style: TextStyle(
          color: AppColors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
