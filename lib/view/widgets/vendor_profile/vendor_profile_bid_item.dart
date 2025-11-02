import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/local/vendor_profile_bid_model.dart';

class VendorProfileBidItem extends StatelessWidget {
  final VendorProfileBidModel bid;

  const VendorProfileBidItem({required this.bid, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(
          color: bid.status == "Active" ? AppColors.borderFFB86A : AppColors.borderE5E7EB,
          width: 2.w,
        ),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bid.status == "Active")
              Row(
                children: [
                  Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      color: AppColors.containerFF6900,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      "ACTIVE BID",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.containerFF6900,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    bid.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.text101828,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 1,
                  child: Text(
                    bid.amount,
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: AppColors.container155DFC,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              "Customer: ${bid.customer}",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text4A5565,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/location_outline.svg",
                  width: 10.w,
                  height: 10.h,
                  colorFilter: ColorFilter.mode(AppColors.text4A5565, BlendMode.srcIn),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    bid.location,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.text4A5565,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Divider(color: AppColors.borderE5E7EB),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/location_outline.svg",
                        width: 10.w,
                        height: 10.h,
                        colorFilter: ColorFilter.mode(AppColors.text4A5565, BlendMode.srcIn),
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          bid.time,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.text4A5565,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 1,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: bid.statusColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          bid.status,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: bid.statusTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
