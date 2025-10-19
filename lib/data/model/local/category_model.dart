import 'package:flutter/material.dart';

class CategoryItemModel {
  final String title;
  final String iconPath;
  final int providers;
  final Color color;
  final LinearGradient? gradient;
  final VoidCallback onTap;

  CategoryItemModel({
    required this.title,
    required this.iconPath,
    required this.providers,
    required this.color,
    required this.onTap,
    this.gradient,
  });
}
