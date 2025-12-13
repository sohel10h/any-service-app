import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileBids extends GetWidget<VendorProfileController> {
  const VendorProfileBids({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(16.w),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Bids",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text101828,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Obx(() {
                  final bidsCount = controller.serviceRequestBidProvider.value?.serviceRequestBidData?.meta?.totalItems ?? 0;
                  return Text(
                    "$bidsCount total",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.text4A5565,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.end,
                  );
                }),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
