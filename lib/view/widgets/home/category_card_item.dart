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
                  colors: item.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: item.iconPath.endsWith(".svg")
                  ? Transform.scale(
                      scale: 1.3,
                      child: SvgPicture.asset(
                        item.iconPath,
                        colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                      ),
                    )
                  : Image.asset(item.iconPath, color: AppColors.white),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
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
                          "${item.providers} Providers",
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
