import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/local/category_model.dart';
import 'package:service_la/view/widgets/home/delayed_widget.dart';
import 'package:service_la/view/widgets/home/category_card_item.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final VoidCallback onShowAll;
  final List<CategoryItemModel> items;

  const CategorySection({
    super.key,
    required this.title,
    required this.onShowAll,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 12.h),
          _buildGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.text333333,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: onShowAll,
          child: Row(
            children: [
              Text(
                "Show all",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SvgPicture.asset(
                "assets/svgs/arrow_right_small.svg",
                width: 16.w,
                height: 16.h,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 12.h,
      ),
      itemBuilder: (context, index) {
        final isLeft = index % 2 == 0;
        final offsetX = isLeft ? -80.0 : 80.0;

        return DelayedWidget(
          delay: Duration(milliseconds: 120 * index),
          child: TweenAnimationBuilder<Offset>(
            tween: Tween(begin: Offset(offsetX, 0), end: const Offset(0, 0)),
            duration: const Duration(milliseconds: 1000),
            // smoother timing
            curve: Curves.easeOutQuart,
            // very smooth easing curve
            builder: (context, offset, child) {
              // fade in progressively with movement
              final opacity = 1 - (offset.dx.abs() / 80);
              return Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.translate(offset: offset, child: child),
              );
            },
            child: CategoryCardItem(item: items[index]),
          ),
        );
      },
    );
  }
}
