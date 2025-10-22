import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownChip<T> extends StatelessWidget {
  final RxList<T> options;
  final Rx<T?> selectedValue;
  final String iconPath;
  final String Function(T) labelBuilder;
  final void Function(T)? onChanged;

  const CustomDropdownChip({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.iconPath,
    required this.labelBuilder,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDropdownOpenRx = false.obs;

    return Container(
      height: 30.h,
      width: Get.width / 3.3,
      decoration: BoxDecoration(
        color: AppColors.containerF3F4F6,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: DropdownButtonHideUnderline(
        child: LayoutBuilder(builder: (context, constraints) {
          return Obx(() {
            final hasOptions = options.isNotEmpty;

            return DropdownButton2<T>(
              isExpanded: true,
              value: selectedValue.value,
              hint: Row(
                children: [
                  SvgPicture.asset(iconPath, width: 16.w, height: 16.h),
                  SizedBox(width: 6.w),
                  Text(
                    hasOptions ? "Select" : "No options",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.text364153,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              items: hasOptions
                  ? options.map((option) {
                      return DropdownMenuItem<T>(
                        value: option,
                        child: Row(
                          children: [
                            SvgPicture.asset(iconPath, width: 16.w, height: 16.h),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                labelBuilder(option),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.text364153,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()
                  : [],
              onChanged: hasOptions
                  ? (value) {
                      selectedValue.value = value;
                      onChanged?.call(value as T);
                    }
                  : null,
              onMenuStateChange: (isOpen) {
                isDropdownOpenRx.value = isOpen;
              },
              dropdownStyleData: DropdownStyleData(
                elevation: 1,
                maxHeight: 200.h,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: AppColors.containerF3F4F6,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.borderE3E7EC),
                ),
                offset: Offset(0, -2.h),
              ),
              iconStyleData: IconStyleData(
                icon: AnimatedRotation(
                  turns: isDropdownOpenRx.value ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(
                    "assets/svgs/arrow_below_small.svg",
                    width: 12.w,
                    height: 12.h,
                  ),
                ),
              ),
              buttonStyleData: ButtonStyleData(
                height: 40.h,
                width: constraints.maxWidth,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
              ),
            );
          });
        }),
      ),
    );
  }
}
