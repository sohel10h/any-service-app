import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/date_time/format_date.dart';
import 'package:service_la/data/model/network/service_request_bid_provider_model.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileBidItem extends StatelessWidget {
  final ServiceRequestBid bid;
  final VendorProfileController controller;

  const VendorProfileBidItem({
    super.key,
    required this.bid,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(
          color: bid.bidStatus == ServiceRequestBidStatus.pending.typeValue
              ? AppColors.borderFFB86A
              : bid.bidStatus == ServiceRequestBidStatus.approved.typeValue
                  ? AppColors.border008236
                  : AppColors.borderE5E7EB,
          width: 2.w,
        ),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bid.bidStatus == ServiceRequestBidStatus.pending.typeValue)
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
                    bid.serviceRequestTitle ?? "",
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
                    "\$${bid.proposedPrice ?? 0}",
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
              "Customer: ${bid.serviceRequestUser ?? ""}",
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
                    "Downtown", //TODO: this field value need to get from API
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
                        "assets/svgs/clock_outline.svg",
                        width: 10.w,
                        height: 10.h,
                        colorFilter: ColorFilter.mode(AppColors.text4A5565, BlendMode.srcIn),
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          formatTimeAgo(bid.bidCreatedOn ?? ""),
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
                          color: bid.serviceRequestStatus == ServiceRequestStatus.completed.typeValue
                              ? AppColors.containerDCFCE7
                              : bid.serviceRequestStatus == ServiceRequestStatus.inProgress.typeValue
                                  ? AppColors.containerFFEDD4
                                  : AppColors.containerF3F4F6, //TODO: this field value need to get from API
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          bid.serviceRequestStatus == ServiceRequestStatus.completed.typeValue
                              ? ServiceRequestStatus.completed.name.toUpperCase()
                              : ServiceRequestStatus.inProgress.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: bid.serviceRequestStatus == ServiceRequestStatus.completed.typeValue
                                ? AppColors.text008236
                                : bid.serviceRequestStatus == ServiceRequestStatus.inProgress.typeValue
                                    ? AppColors.textCA3500
                                    : AppColors.text364153, //TODO: this field value need to get from API
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
