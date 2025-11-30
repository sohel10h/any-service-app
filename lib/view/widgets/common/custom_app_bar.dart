import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_back_button.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final String? title;
  final TextStyle? textStyle;
  final Widget? backButton;
  final bool centerTitle;
  final List<Widget> actions;
  final VoidCallback? onBackButtonPressed;
  final String? iconPath;
  final bool? isOnlyIcon;
  final double? leadingWidth;
  final VoidCallback? onTap;

  const CustomAppbar({
    super.key,
    this.onBackButtonPressed,
    this.iconPath,
    this.isOnlyIcon,
    this.titleWidget,
    this.title,
    this.backButton,
    this.textStyle,
    this.centerTitle = true,
    this.actions = const [],
    this.leadingWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidth ?? 56.w,
      centerTitle: centerTitle,
      leading: backButton ?? CustomBackButton(onTap: onTap),
      title: titleWidget ??
          Text(
            title ?? "",
            style: textStyle ??
                TextStyle(
                  fontSize: 17.sp,
                  color: AppColors.text101828,
                  fontWeight: FontWeight.w700,
                ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
