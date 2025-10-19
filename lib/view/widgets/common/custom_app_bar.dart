import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TextStyle? textStyle;
  final bool isBackButton;
  final List<Widget> actions;
  final VoidCallback? onBackButtonPressed;
  final String? iconPath;
  final bool? isOnlyIcon;

  const CustomAppbar({
    super.key,
    this.onBackButtonPressed,
    this.iconPath,
    this.isOnlyIcon,
    required this.title,
    this.textStyle,
    this.isBackButton = true,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 10,
      leading: isBackButton ? Icon(Icons.arrow_back_ios) : null,
      title: Text(
        title,
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
