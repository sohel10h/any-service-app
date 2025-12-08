import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/search/controller/search_screen_controller.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: controller.onCloseTap,
                        child: Container(
                          width: 34.w,
                          height: 34.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.black.withValues(alpha: .05),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 20),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomTextField(
                          height: 35.h,
                          controller: controller.searchController,
                          focusNode: controller.searchFocusNode,
                          hintText: "Search services...",
                          labelStyle: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.text414651,
                            fontWeight: FontWeight.w500,
                          ),
                          hintStyle: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.text757575,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIconPath: "assets/svgs/search.svg",
                          textInputAction: TextInputAction.search,
                          onChanged: (searchServices) => controller.formKey.currentState?.validate(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.r),
                            borderSide: BorderSide(color: AppColors.borderE3E7EC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Recent Searches",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.text6A7282,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    children: [
                      _searchItem("Repair Service"),
                      _searchItem("Car Wash"),
                      _searchItem("Electrician"),
                      _searchItem("House Cleaning"),
                      _searchItem("Bike Mechanic"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchItem(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.text6A7282,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
