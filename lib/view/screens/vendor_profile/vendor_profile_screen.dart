import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
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
          if (!didPop && controller.landingController.currentIndex.value != 0) {
            controller.landingController.changeIndex(0, context);
          }
        },
        child: Scaffold(
          appBar: CustomAppbar(
            isBackButton: true,
            backButton: Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: GestureDetector(
                onTap: () => controller.landingController.changeIndex(0, context),
                child: Container(
                  width: 31.w,
                  height: 31.w,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.containerF3F4F6,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/svgs/arrow_left.svg",
                    width: 14.w,
                    height: 14.h,
                  ),
                ),
              ),
            ),
            centerTitle: true,
            title: "Vendor Profile",
            textStyle: TextStyle(
              fontSize: 17.sp,
              color: AppColors.text101828,
              fontWeight: FontWeight.w700,
            ),
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
          body: DefaultTabController(
            length: controller.tabs.length,
            initialIndex: controller.selectedTabIndex.value,
            child: NestedScrollView(
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
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  VendorProfileBidsTab(),
                  VendorProfileServicesTab(),
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
