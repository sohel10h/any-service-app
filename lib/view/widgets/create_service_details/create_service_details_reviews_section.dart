import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/common/utils/date_time/format_date.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/create_service/controller/create_service_details_controller.dart';

class CreateServiceDetailsReviewsSection extends GetWidget<CreateServiceDetailsController> {
  const CreateServiceDetailsReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: 8.h),
        _buildReviews(),
      ],
    );
  }

  Widget _buildReviews() {
    return Obx(() {
      final reviews = controller.createServiceDetailsData.value.reviews;
      if (reviews == null || reviews.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 48.h),
          child: NoDataFound(
            message: "No reviews found!",
            onPressed: controller.onRefresh,
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          final reviewWidget = _reviewsItem(
            userId: review.user?.id,
            image: review.picture?.virtualPath ?? "",
            name: review.user?.name ?? "",
            timeAgo: formatTimeAgo(review.review?.createdAt ?? ""),
            review: review.review?.reviewText ?? "",
            rating: review.user?.rating ?? 0,
          );
          if (index < reviews.length - 1) {
            return Column(
              children: [
                reviewWidget,
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(color: AppColors.containerF3F4F6),
                ),
                SizedBox(height: 12.h),
              ],
            );
          } else {
            return reviewWidget;
          }
        },
      );
    });
  }

  Widget _reviewsItem({
    required String? userId,
    required String image,
    required String name,
    required String timeAgo,
    required String review,
    required num rating,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => controller.goToProfileScreen(userId),
                  child: NetworkImageLoader(
                    image,
                    width: 28.w,
                    height: 28.w,
                    borderRadius: BorderRadius.circular(30.r),
                    isUserImage: true,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.text101828,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: List.generate(
                          rating.toInt(),
                          (index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: SvgPicture.asset(
                                index < rating ? "assets/svgs/rating.svg" : "assets/svgs/rating_outline.svg",
                                width: 12.w,
                                height: 12.h,
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
                    alignment: Alignment.centerRight,
                    child: Text(
                      timeAgo,
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
            SizedBox(height: 8.h),
            Text(
              review,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.text4A5565,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      final reviews = controller.createServiceDetailsData.value.reviews;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                "Reviews (${reviews?.length ?? 0})",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.text101828,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        "View all",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/svgs/arrow_right_small.svg",
                      width: 14.w,
                      height: 14.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
