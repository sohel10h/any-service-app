import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDataFound extends StatelessWidget {
  final String? message;
  final bool? isRefresh;
  final VoidCallback? onPressed;

  const NoDataFound({
    super.key,
    this.message,
    this.isRefresh,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            message ?? "No data found!",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.text6A7282,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (isRefresh ?? true)
          IconButton(
            onPressed: onPressed ?? () {},
            icon: Icon(Icons.refresh, color: AppColors.text6A7282),
          )
      ],
    );
  }
}
