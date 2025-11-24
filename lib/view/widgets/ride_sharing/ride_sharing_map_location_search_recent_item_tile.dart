import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideSharingMapLocationSearchRecentItemTile extends StatelessWidget {
  final String title;
  final String distance;
  final String address;

  const RideSharingMapLocationSearchRecentItemTile({
    super.key,
    required this.title,
    required this.distance,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset("assets/svgs/location_outline.svg"),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.text101828,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        "${distance}km",
        style: TextStyle(
          fontSize: 10.sp,
          color: AppColors.text6A7282,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.more_vert,
        color: AppColors.black.withValues(alpha: .3),
      ),
    );
  }
}
