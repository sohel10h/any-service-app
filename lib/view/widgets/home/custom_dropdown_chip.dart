import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownChip<T> extends StatelessWidget {
  final double? width;
  final double? height;
  final RxList<T> options;
  final Rx<T?> selectedValue;
  final String? iconPath;
  final String? hint;
  final String Function(T) labelBuilder;
  final void Function(T)? onChanged;
  final bool? isDisabled;

  const CustomDropdownChip({
    super.key,
    this.width,
    this.height,
    required this.options,
    required this.selectedValue,
    this.iconPath,
    this.hint,
    required this.labelBuilder,
    this.onChanged,
    this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDropdownOpenRx = false.obs;

    return Container(
      width: width ?? Get.width / 3,
      height: height ?? 30.h,
      decoration: BoxDecoration(
        color: (isDisabled ?? false) ? AppColors.containerD1D5DC.withValues(alpha: .3) : AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.containerD1D5DC),
      ),
      child: DropdownButtonHideUnderline(
        child: LayoutBuilder(builder: (context, constraints) {
          return Obx(() {
            final hasOptions = options.isNotEmpty;
            return IgnorePointer(
              ignoring: (isDisabled ?? false),
              child: DropdownButton2<T>(
                isExpanded: true,
                value: selectedValue.value,
                hint: Row(
                  children: [
                    if (iconPath != null) ...[
                      SvgPicture.asset(
                        iconPath ?? "",
                        width: 16.w,
                        height: 16.h,
                      ),
                      SizedBox(width: 6.w),
                    ],
                    Flexible(
                      child: Text(
                        hasOptions ? hint ?? "Select" : "No options",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.text364153,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                              if (iconPath != null) ...[
                                SvgPicture.asset(
                                  iconPath ?? "",
                                  width: 16.w,
                                  height: 16.h,
                                ),
                                SizedBox(width: 6.w),
                              ],
                              Expanded(
                                child: Text(
                                  labelBuilder(option),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: (isDisabled ?? false) ? AppColors.text364153.withValues(alpha: 0.5) : AppColors.text364153,
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
                onChanged: (hasOptions && (!(isDisabled ?? true)))
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
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  offset: Offset(0, -4.h),
                ),
                iconStyleData: IconStyleData(
                  icon: AnimatedRotation(
                    turns: isDropdownOpenRx.value ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: SvgPicture.asset(
                      "assets/svgs/arrow_below_small.svg",
                      width: 12.w,
                      height: 12.h,
                      colorFilter: ColorFilter.mode(
                        (isDisabled ?? false) ? AppColors.text364153.withValues(alpha: .5) : AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                buttonStyleData: ButtonStyleData(
                  height: 40.h,
                  width: constraints.maxWidth,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}
