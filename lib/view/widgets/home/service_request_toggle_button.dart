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
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderE8E8E8),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.sp),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isIndividualSelected = true;
                    widget.onValueChanged(isIndividualSelected);
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isIndividualSelected ? AppColors.primary : AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                child: Text(
                  "Individual",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isIndividualSelected ? AppColors.white : AppColors.text6A7282,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isIndividualSelected = false;
                    widget.onValueChanged(isIndividualSelected);
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: !isIndividualSelected ? AppColors.primary : AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                child: Text(
                  "Corporate",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isIndividualSelected ? AppColors.text6A7282 : AppColors.white,
                    fontWeight: FontWeight.w500,
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
