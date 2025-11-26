import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RideSharingMapLocationSearchRecentItemTile extends StatelessWidget {
  final String title;
  final String distance;
  final String address;
  final bool isSaved;
  final bool isRemoved;
  final VoidCallback? onSave;
  final VoidCallback? onRemove;

  const RideSharingMapLocationSearchRecentItemTile({
    super.key,
    required this.title,
    required this.distance,
    required this.address,
    this.isSaved = true,
    this.isRemoved = true,
    this.onSave,
    this.onRemove,
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
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: AppColors.black.withValues(alpha: .3),
        ),
        offset: const Offset(-35, -1),
        position: PopupMenuPosition.under,
        onSelected: (value) {
          if (value == "save" && onSave != null) {
            onSave!();
          } else if (value == "remove" && onRemove != null) {
            onRemove!();
          }
        },
        itemBuilder: (context) => [
          if (isSaved)
            const PopupMenuItem<String>(
              value: "save",
              child: Text("Save"),
            ),
          if (isRemoved)
            const PopupMenuItem<String>(
              value: "remove",
              child: Text("Remove"),
            ),
        ],
      ),
    );
  }
}
