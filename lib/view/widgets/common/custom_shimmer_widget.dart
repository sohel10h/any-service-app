import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class CustomShimmerWidget extends StatelessWidget {
  final Widget child;

  const CustomShimmerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }
}
