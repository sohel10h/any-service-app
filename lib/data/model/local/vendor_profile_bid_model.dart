import 'package:flutter/material.dart';

class VendorProfileBidModel {
  final String title;
  final String customer;
  final String location;
  final String time;
  final String status;
  final String amount;
  final Color statusColor;
  final Color statusTextColor;

  VendorProfileBidModel({
    required this.title,
    required this.customer,
    required this.location,
    required this.time,
    required this.status,
    required this.amount,
    required this.statusColor,
    required this.statusTextColor,
  });
}
