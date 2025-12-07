import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/date_time/format_date.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/data/model/network/common/service_review_model.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileReviewItem extends StatelessWidget {
  final ServiceReviewModel review;
  final VendorProfileController controller;

  const VendorProfileReviewItem({
    super.key,
    required this.review,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // TODO: future development
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(color: AppColors.borderE5E7EB),
        ),
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.loadProfile(review.user?.id),
                    child: NetworkImageLoader(
                      review.picture?.virtualPath ?? "",
                      width: 40.w,
                      height: 40.w,
                      borderRadius: BorderRadius.circular(60.r),
                      isUserImage: true,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.user?.name ?? "",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.text101828,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: List.generate(
                            (review.review?.rating?.toInt() ?? 0),
                            (index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 3.w),
                                child: SvgPicture.asset(
                                  index < (review.review?.rating?.toInt() ?? 0)
                                      ? "assets/svgs/rating.svg"
                                      : "assets/svgs/rating_outline.svg",
                                  width: 14.w,
                                  height: 14.h,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        formatTimeAgo(review.review?.createdAt ?? ""),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.text6A7282,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                review.review?.reviewText ?? "",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.text4A5565,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
