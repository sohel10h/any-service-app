import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/widgets/common/custom_text_field_shimmer.dart';
import 'package:service_la/view/widgets/ride_sharing/ride_sharing_map_location_search_item_shimmer.dart';
import 'package:service_la/view/widgets/ride_sharing/ride_sharing_map_location_search_recent_item_tile.dart';
import 'package:service_la/view/screens/ride_sharing/controller/ride_sharing_map_location_search_controller.dart';

class RideSharingMapLocationSearchScreen extends GetWidget<RideSharingMapLocationSearchController> {
  const RideSharingMapLocationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        isBackButton: true,
        backButton: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: GestureDetector(
            onTap: () => Get.back(),
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
        title: "Search Location",
        textStyle: TextStyle(
          fontSize: 17.sp,
          color: AppColors.text101828,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 12.h),
          _buildSearchFields(),
          SizedBox(height: 12.h),
          _buildPriceToggle(),
          SizedBox(height: 12.h),
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 12.h),
                Icon(Icons.radio_button_checked, color: AppColors.green, size: 18.sp),
                SizedBox(height: 2.h),
                Container(
                  width: 5.w,
                  height: 5.w,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.borderE5E7EB.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 5.w,
                  height: 5.w,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.borderE5E7EB.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: 5.w,
                  height: 5.w,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.borderE5E7EB.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 2.h),
                SvgPicture.asset("assets/svgs/location_outline.svg"),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                children: [
                  Obx(() {
                    final isLoading = controller.isLoadingCurrentLocation.value;
                    return isLoading
                        ? CustomTextFieldShimmer()
                        : CustomTextField(
                            controller: controller.locationFromController,
                            focusNode: controller.locationFromFocusNode,
                            hintText: "From",
                            onChanged: (val) => controller.onQueryChanged(val, isFrom: true),
                          );
                  }),
                  SizedBox(height: 12.h),
                  CustomTextField(
                    controller: controller.locationToController,
                    focusNode: controller.locationToFocusNode,
                    hintText: "To",
                    onChanged: (val) => controller.onQueryChanged(val, isFrom: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceToggle() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Add Proposed Price",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.text6A7282,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: controller.isPriceToggleOn.value,
                  onChanged: (val) => controller.isPriceToggleOn.value = val,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.9),
                  inactiveThumbColor: AppColors.borderD5D7DA,
                  inactiveTrackColor: AppColors.borderE5E7EB.withValues(alpha: 0.7),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                  splashRadius: 24.r,
                ),
              ],
            ),
            if (controller.isPriceToggleOn.value) ...[
              SizedBox(height: 8.h),
              CustomTextField(
                controller: controller.priceController,
                focusNode: controller.priceFocusNode,
                textInputType: TextInputType.number,
                hintText: "Enter proposed price",
                prefixIconPath: "assets/svgs/dollar.svg",
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildSearchResults() {
    return Obx(() {
      final stream = controller.isLocationFromSearch.value ? controller.fromAutoCompleteStream : controller.toAutoCompleteStream;
      return StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          final suggestions = snap.data ?? [];
          if (controller.isSearchingLocation.value) {
            return _buildShimmerList();
          }
          if (suggestions.isEmpty) {
            return _buildTabsAndLists();
          }
          return ListView.separated(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 8.h),
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Divider(color: AppColors.dividerE9EAEB),
            ),
            itemBuilder: (_, i) {
              final item = suggestions[i];
              return InkWell(
                onTap: () {
                  controller.goToRideSharingMapScreen(
                    item["lat"] ?? 0.0,
                    item["lng"] ?? 0.0,
                    item["description"] ?? "",
                  );
                },
                child: RideSharingMapLocationSearchRecentItemTile(
                  title: item["description"] ?? "",
                  address: "${item["locality"] ?? ""}, ${item["postal_code"] ?? ""}",
                  distance: "${item["distanceKm"] ?? ""}",
                ),
              );
            },
          );
        },
      );
    });
  }

  Widget _buildTabsAndLists() {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _tab("Recent", 0),
            _tab("Suggested", 1),
            _tab("Saved", 2),
          ],
        ),
        SizedBox(height: 12.h),
        Expanded(child: _buildTabContent()),
      ],
    );
  }

  Widget _tab(String label, int index) {
    return Obx(() {
      final isSelected = controller.tabIndex.value == index;
      return GestureDetector(
        onTap: () => controller.tabIndex.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? AppColors.primary : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabContent() {
    return Obx(() {
      List<Map<String, dynamic>> list;

      if (controller.tabIndex.value == 0) {
        list = controller.recentList;
      } else if (controller.tabIndex.value == 1) {
        list = controller.suggestedList;
      } else {
        list = controller.savedList;
      }

      if (list.isEmpty) {
        return Center(
          child: Text(
            "No items found",
            style: TextStyle(color: Colors.grey, fontSize: 13.sp),
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 8.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Divider(color: AppColors.dividerE9EAEB),
        ),
        itemBuilder: (_, i) {
          final item = list[i];
          return RideSharingMapLocationSearchRecentItemTile(
            title: item["description"] ?? "",
            address: "${item["locality"] ?? ""}, ${item["postal_code"] ?? ""}",
            distance: "${item["distanceKm"] ?? ""}",
          );
        },
      );
    });
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemBuilder: (_, __) => RideSharingMapLocationSearchItemShimmer(),
    );
  }
}
