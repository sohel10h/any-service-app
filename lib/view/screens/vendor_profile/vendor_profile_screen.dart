import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_tab.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_header.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bids_tab.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_services_tab.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_requests_tab.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_tab_bar_header_delegate.dart';

class VendorProfileScreen extends GetWidget<VendorProfileController> {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.landingController.currentIndex.value == 0,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            if (controller.landingController.currentIndex.value != 0) {
              controller.landingController.changeIndex(0, context);
            }
            Get.back();
          }
        },
        child: Scaffold(
          appBar: CustomAppbar(
            title: "Vendor Profile",
            onTap: () {
              if (controller.landingController.currentIndex.value != 0) {
                controller.landingController.changeIndex(0, context);
              }
              Future.microtask(() => Get.back());
            },
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Container(
                  width: 31.w,
                  height: 31.w,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.containerF3F4F6,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/svgs/share.svg",
                    width: 14.w,
                    height: 14.h,
                  ),
                ),
              ),
            ],
          ),
          body: controller.isLoadingAdminUser.value
              ? CustomProgressBar()
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SizedBox(height: 16.h),
                              VendorProfileHeader(),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: VendorProfileTabBarHeaderDelegate(
                          minHeight: 40.h,
                          maxHeight: 40.h,
                          child: VendorProfileTab(isFromNestedScroll: true),
                        ),
                      ),
                    ];
                  },
                  body: RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.white,
                    onRefresh: controller.refreshAdminUser,
                    notificationPredicate: (notification) {
                      return notification.depth == 1;
                    },
                    child: TabBarView(
                      controller: controller.tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        if (controller.userId == null) VendorProfileBidsTab(),
                        if (controller.userId == null) VendorProfileServicesTab(),
                        VendorProfileServiceRequestsTab(),
                        VendorProfileServiceRequestsTab(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
