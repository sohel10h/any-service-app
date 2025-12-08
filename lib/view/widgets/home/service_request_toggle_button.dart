import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceRequestToggleButton extends StatefulWidget {
  final Function(bool isIndividualSelected) onValueChanged;

  const ServiceRequestToggleButton({super.key, required this.onValueChanged});

  @override
  State<ServiceRequestToggleButton> createState() => _ServiceRequestToggleButtonState();
}

class _ServiceRequestToggleButtonState extends State<ServiceRequestToggleButton> {
  bool isIndividualSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.borderE8E8E8),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.sp),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isIndividualSelected = true;
                    widget.onValueChanged(isIndividualSelected);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isIndividualSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: isIndividualSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                    border: Border.all(
                      color: isIndividualSelected ? AppColors.primary : AppColors.borderE8E8E8,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Individual",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isIndividualSelected ? AppColors.white : AppColors.text364153,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isIndividualSelected = false;
                    widget.onValueChanged(isIndividualSelected);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: !isIndividualSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: !isIndividualSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                    border: Border.all(
                      color: !isIndividualSelected ? AppColors.primary : AppColors.borderE8E8E8,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Corporate",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: !isIndividualSelected ? AppColors.white : AppColors.text364153,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
