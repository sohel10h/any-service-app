import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_shimmer_widget.dart';

class ChatsMessageShimmer extends StatelessWidget {
  final bool isMe;

  const ChatsMessageShimmer({super.key, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: CustomShimmerWidget(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4.h),
          padding: EdgeInsets.all(12.sp),
          constraints: const BoxConstraints(maxWidth: 260),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primary.withValues(alpha: .3) : AppColors.dividerE9EAEB.withValues(alpha: .2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: isMe ? Radius.circular(16.r) : const Radius.circular(0),
              bottomRight: isMe ? const Radius.circular(0) : Radius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                height: 12.h,
                width: 120.w,
                color: Colors.white,
              ),
              SizedBox(height: 8.h),
              Container(
                height: 10.h,
                width: 40.w,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
