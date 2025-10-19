import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/local/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryItemModel item;

  const CategoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.all(8.h),
        child: Row(
          children: [
            Container(
              height: 44.w,
              width: 44.w,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: item.iconPath.endsWith(".svg")
                  ? SvgPicture.asset(
                      item.iconPath,
                      colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                      fit: BoxFit.scaleDown,
                    )
                  : Image.asset(item.iconPath, color: AppColors.white),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${item.providers} Providers",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.white.withValues(alpha: .8),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
