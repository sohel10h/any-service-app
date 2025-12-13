import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/network/service_me_model.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileServiceItem extends StatelessWidget {
  final ServiceMeData service;
  final VendorProfileController controller;

  const VendorProfileServiceItem({
    super.key,
    required this.service,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.goToCreateServiceDetailsScreen(service.id ?? ""),
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(color: AppColors.borderE5E7EB),
        ),
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImageLoader(
                service.picture?.virtualPath ?? "",
                width: 40.w,
                height: 40.w,
                borderRadius: BorderRadius.circular(8.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          service.name ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.text101828,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.more_vert, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      service.description ?? "",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.text4A5565,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      service.price == null ? "${service.priceStart ?? 0}-${service.priceEnd ?? 0}" : "${service.price ?? 0}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.containerDCFCE7, //TODO: need to get this data from API
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Active", //TODO: need to get this data from API
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.text008236, //TODO: need to get this data from API
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
