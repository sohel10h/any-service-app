import 'package:flutter/material.dart';

class FileOptionModel {
  final int? id;
  final String? image;
  final VoidCallback? onTap;

  FileOptionModel({
    this.id,
    this.image,
    this.onTap,
  });
}
