import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? textStyle;
  final bool isBackButton;
  final Widget? backButton;
  final bool centerTitle;
  final List<Widget> actions;
  final VoidCallback? onBackButtonPressed;
  final String? iconPath;
  final bool? isOnlyIcon;

  const CustomAppbar({
    super.key,
    this.onBackButtonPressed,
    this.iconPath,
    this.isOnlyIcon,
    this.title,
    this.backButton,
    this.textStyle,
    this.isBackButton = true,
    this.centerTitle = false,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 56,
      centerTitle: centerTitle,
      leading: isBackButton
          ? backButton
          : Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Icon(Icons.arrow_back_ios, color: AppColors.black),
            ),
      title: title == null
          ? const SizedBox.shrink()
          : Text(
              title ?? "",
              style: textStyle ??
                  TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
