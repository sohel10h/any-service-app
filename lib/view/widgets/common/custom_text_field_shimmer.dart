import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_shimmer_widget.dart';

class CustomTextFieldShimmer extends StatelessWidget {
  const CustomTextFieldShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmerWidget(
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
