import 'package:flutter/material.dart';

class VendorProfileServiceModel {
  final String title;
  final String category;
  final String price;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String image;

  VendorProfileServiceModel({
    required this.title,
    required this.category,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.image,
  });
}
