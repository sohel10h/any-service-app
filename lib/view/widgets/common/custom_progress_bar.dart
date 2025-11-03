import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';

class CustomProgressBar extends StatelessWidget {
  final Color? color;
  final double? size;
  final double? strokeWidth;

  const CustomProgressBar({
    super.key,
    this.color,
    this.size,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(
      color: color ?? AppColors.primary,
      strokeWidth: strokeWidth ?? 4.0,
    );

    final progressBar = Center(
      child: size != null ? SizedBox(width: size, height: size, child: indicator) : indicator,
    );

    return progressBar;
  }
}
