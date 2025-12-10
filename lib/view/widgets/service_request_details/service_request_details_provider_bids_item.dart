import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/common/bid_model.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class ServiceRequestDetailsProviderBidsItem extends StatelessWidget {
  final BidModel bid;
  final VoidCallback onAccept;
  final VoidCallback onShortlist;
  final VoidCallback onReject;
  final VoidCallback onMessage;
  final RxBool isApprovedLoading;
  final RxBool isShortlistedLoading;
  final RxBool isRejectedLoading;
  final ServiceRequestDetailsController controller;

  const ServiceRequestDetailsProviderBidsItem({
    super.key,
    required this.bid,
    required this.onAccept,
    required this.onShortlist,
    required this.onReject,
    required this.onMessage,
    required this.isApprovedLoading,
    required this.isShortlistedLoading,
    required this.isRejectedLoading,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
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
                GestureDetector(
                  onTap: () => controller.goToProfileScreen(bid.vendor?.id),
                  child: NetworkImageLoader(
                    bid.vendor?.virtualPath ?? "",
                    width: 32.w,
                    height: 32.w,
                    borderRadius: BorderRadius.circular(30.r),
                    isUserImage: true,
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.vendor?.name ?? "",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.text101828,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        bid.vendor?.name ?? "", //TODO: need user title value from API
                        style: TextStyle(
                          fontSize: 11.sp,
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
                              "\$${bid.proposedPrice ?? 0}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          if (false) //TODO: need isBest value from API
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
                      if (HelperFunction.isBidBelowBudget(controller.serviceDetailsData.value.budgetMin, bid.proposedPrice))
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, color: AppColors.green, size: 9.sp),
                            SizedBox(width: 4.w),
                            Text(
                              "Below budget",
                              style: TextStyle(
                                fontSize: 9.sp,
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
                  width: 10.w,
                  height: 10.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  "${bid.vendor?.rating?.toStringAsFixed(2) ?? 0}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.text364153,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  " (${bid.vendor?.rating?.toStringAsFixed(2) ?? 0})", //TODO: need reviewsCount value from API
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.text6A7282,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  "assets/svgs/check_circle.svg",
                  width: 10.w,
                  height: 10.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  "${bid.vendor?.serviceCompletedCount ?? 0} jobs",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.text4A5565,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  "assets/svgs/clock_outline.svg",
                  width: 10.w,
                  height: 10.h,
                  colorFilter: ColorFilter.mode(AppColors.text6A7282, BlendMode.srcIn),
                ),
                SizedBox(width: 4.w),
                Text(
                  "1 hour ago", //TODO need responseTime value from API
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.text6A7282,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              bid.message ?? "",
              style: TextStyle(
                fontSize: 12.sp,
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
                  text: "Available next week", //TODO: need availability value from API
                  iconColor: AppColors.primary,
                  textColor: AppColors.primary,
                ),
                _buildTagItem(
                  iconPath: "assets/svgs/clock_outline.svg",
                  text: "4-5 hours", //TODO: need duration value from API
                  iconColor: AppColors.primary,
                  textColor: AppColors.primary,
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
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 0,
              child: SvgPicture.asset(
                iconPath,
                width: 10.w,
                height: 10.h,
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
                  fontSize: 11.sp,
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
        ...!((bid.userApproved ?? false) && (bid.vendorApproved ?? false))
            ? []
            : [
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: AppColors.white, size: 15.sp),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          "This bid has been approved and is ready for further action.",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
        ...!((bid.status == ServiceRequestBidStatus.rejected.typeValue))
            ? []
            : [
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cancel, color: AppColors.white, size: 15.sp),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          "This bid has been rejected and will not proceed further.",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
        Obx(() {
          final loading = isApprovedLoading.value;
          final isApproved = bid.userApproved ?? false;
          final buttonLabel = isApproved ? "Unapprove Bid" : "Accept Bid";
          final isServiceRequestCompleted = controller.serviceDetailsData.value.status == ServiceRequestStatus.completed.typeValue;
          if (isServiceRequestCompleted) return const SizedBox.shrink();
          final isBothApproved = controller.isBidBothApproved.value;
          if (isBothApproved) return const SizedBox.shrink();
          final isRejected = bid.status == ServiceRequestBidStatus.rejected.typeValue;
          if (isRejected) return const SizedBox.shrink();
          return Column(
            children: [
              SizedBox(height: 8.h),
              if (loading)
                CustomProgressBar()
              else
                (isApproved
                    ? ElevatedButton(
                        onPressed: onAccept,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          minimumSize: Size(double.infinity, 32.h),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          buttonLabel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : OutlinedButton(
                        onPressed: onAccept,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          minimumSize: Size(double.infinity, 32.h),
                          side: BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          buttonLabel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => _iconButton(
                        containerColor: AppColors.containerFAF5FF,
                        borderColor: AppColors.borderE9D4FF,
                        iconPath: (bid.isShortlisted ?? false) ? "assets/svgs/heart_fill.svg" : "assets/svgs/heart_outline.svg",
                        label: "Shortlist",
                        color: AppColors.text8200DB,
                        onTap: onShortlist,
                        isShortlistedLoading: isShortlistedLoading,
                      ),
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
                    child: Obx(
                      () => _iconButton(
                        containerColor: AppColors.white,
                        borderColor: AppColors.borderFFC9C9,
                        iconPath: "assets/svgs/close.svg",
                        label: "",
                        onTap: onReject,
                        color: AppColors.red,
                        isRejectedLoading: isRejectedLoading,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
        controller.isBidBothApproved.value || bid.status == ServiceRequestBidStatus.rejected.typeValue
            ? const SizedBox.shrink()
            : SizedBox(height: 4.h),
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
    RxBool? isShortlistedLoading,
    RxBool? isRejectedLoading,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: 80.w, maxWidth: double.infinity),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (isShortlistedLoading?.value ?? false) || (isRejectedLoading?.value ?? false)
                  ? CustomProgressBar(
                      size: 12.sp,
                      strokeWidth: 2,
                      color: (isShortlistedLoading?.value ?? false) ? AppColors.text8200DB : AppColors.red,
                    )
                  : SvgPicture.asset(
                      iconPath,
                      width: 12.w,
                      height: 12.h,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
              if (label != null) ...[
                SizedBox(width: 6.w),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.sp,
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
