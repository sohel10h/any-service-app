import 'package:flutter/material.dart';

class CategoryItemModel {
  final String title;
  final String iconPath;
  final int providers;
  final List<Color> colors;
  final VoidCallback onTap;

  CategoryItemModel({
    required this.title,
    required this.iconPath,
    required this.providers,
    required this.colors,
    required this.onTap,
  });
}
