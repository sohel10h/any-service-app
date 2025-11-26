import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/common/category_model.dart';

class CategoryCardItem extends StatelessWidget {
  final CategoryModel serviceCategory;

  const CategoryCardItem({super.key, required this.serviceCategory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // TODO: future implement
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderE3E7EC),
        ),
        padding: EdgeInsets.all(8.h),
        child: Row(
          children: [
            Container(
              height: 52.w,
              width: 52.w,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  colors: HelperFunction.getCategoriesColors(serviceCategory.name ?? ""),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Transform.scale(
                scale: 1.3,
                child: SvgPicture.asset(
                  HelperFunction.getServiceIconPath(serviceCategory.name ?? ""),
                  colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    serviceCategory.name ?? "",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: AppColors.container00C950,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          "${serviceCategory.id?.length} Providers", // TODO: need this providers value from API
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.black.withValues(alpha: .6),
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
