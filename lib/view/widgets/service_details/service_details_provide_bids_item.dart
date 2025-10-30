import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/local/provider_bid_model.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';

class ServiceDetailsProviderBidsItem extends StatelessWidget {
  final ProviderBidModel bid;
  final VoidCallback onAccept;
  final VoidCallback onShortlist;
  final VoidCallback onReject;
  final VoidCallback onMessage;

  const ServiceDetailsProviderBidsItem({
    super.key,
    required this.bid,
    required this.onAccept,
    required this.onShortlist,
    required this.onReject,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.containerE5E7EB),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImageLoader(
                  bid.imageUrl,
                  width: 42.w,
                  height: 42.w,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.text101828,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        bid.title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.text6A7282,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "\$${bid.price}",
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: AppColors.container155DFC,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          if (bid.isBest)
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 4.w),
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.containerDCFCE7,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      "Best",
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        color: AppColors.text008236,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (bid.belowBudget)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, color: AppColors.green, size: 12.sp),
                            SizedBox(width: 4.w),
                            Text(
                              "Below budget",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.text6A7282,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svgs/rating.svg",
                  width: 14.w,
                  height: 14.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  "${bid.rating}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.text364153,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  " (${bid.jobsCount})",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text6A7282,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  "assets/svgs/check_circle.svg",
                  width: 14.w,
                  height: 14.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  "${bid.jobsCount} jobs",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text4A5565,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  "assets/svgs/clock_outline.svg",
                  width: 14.w,
                  height: 14.h,
                  colorFilter: ColorFilter.mode(AppColors.text6A7282, BlendMode.srcIn),
                ),
                SizedBox(width: 4.w),
                Text(
                  bid.timeAgo,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text6A7282,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              bid.description,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.text364153,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildTagItem(
                  iconPath: "assets/svgs/calendar_outline.svg",
                  text: bid.availability,
                  iconColor: AppColors.text1447E6,
                  textColor: AppColors.text1447E6,
                ),
                _buildTagItem(
                  iconPath: "assets/svgs/clock_outline.svg",
                  text: bid.duration,
                  iconColor: AppColors.text364153,
                  textColor: AppColors.text364153,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTagItem({
    required String iconPath,
    required String text,
    required Color iconColor,
    required Color textColor,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 0.65.sw,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.containerEFF6FF,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 0,
              child: SvgPicture.asset(
                iconPath,
                width: 14.w,
                height: 14.h,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: 6.w),
            Flexible(
              flex: 1,
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(height: 8.h),
        ElevatedButton(
          onPressed: onAccept,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 42.h),
            backgroundColor: AppColors.container155DFC,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            "Accept Bid",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: _iconButton(
                containerColor: AppColors.containerFAF5FF,
                borderColor: AppColors.borderE9D4FF,
                iconPath: bid.shortlisted ? "assets/svgs/heart_fill.svg" : "assets/svgs/heart_outline.svg",
                label: "Shortlist",
                color: AppColors.text8200DB,
                onTap: onShortlist,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 1,
              child: _iconButton(
                containerColor: AppColors.white,
                borderColor: AppColors.containerE5E7EB,
                iconPath: "assets/svgs/message_bubble.svg",
                label: "",
                color: AppColors.black,
                onTap: onMessage,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 1,
              child: _iconButton(
                containerColor: AppColors.white,
                borderColor: AppColors.borderFFC9C9,
                iconPath: "assets/svgs/close.svg",
                label: "",
                onTap: onReject,
                color: AppColors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _iconButton({
    required VoidCallback onTap,
    String? label,
    required String iconPath,
    required Color color,
    required Color containerColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: 80.w, maxWidth: double.infinity),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 14.w,
                height: 14.h,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              if (label != null) ...[
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
