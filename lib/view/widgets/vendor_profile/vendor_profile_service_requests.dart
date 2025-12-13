import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/home/custom_dropdown_chip.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileServiceRequests extends GetWidget<VendorProfileController> {
  const VendorProfileServiceRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(16.w),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              Expanded(
                child: Text(
                  "Service Requests",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text101828,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => CustomDropdownChip<ServiceRequestStatus>(
                  width: Get.width / 3,
                  height: 30.h,
                  options: ServiceRequestStatus.values.obs,
                  selectedValue: controller.selectedServiceRequestStatus,
                  hint: "Select status",
                  fontSize: 11.sp,
                  labelBuilder: (status) => status.name.toUpperCase(),
                  onChanged: (status) {
                    if (status == ServiceRequestStatus.all) {
                      controller.selectedServiceRequestStatus.value = null;
                    }
                    controller.refreshServiceRequestsMe(isLoadingStatus: true, isLoadingEmpty: true);
                  },
                  isDisabled: controller.isDropdownDisabled.value,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
