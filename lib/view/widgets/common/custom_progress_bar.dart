import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';

class CustomProgressBar extends StatelessWidget {
  final Color? color;
  final bool? isPositioned;

  const CustomProgressBar({super.key, this.color, this.isPositioned});

  @override
  Widget build(BuildContext context) {
    return isPositioned != null
        ? Positioned(
            left: 0.0,
            top: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Center(
              child: CircularProgressIndicator(color: color ?? AppColors.primary),
            ),
          )
        : Center(
            child: CircularProgressIndicator(color: color ?? AppColors.primary),
          );
  }
}
