import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  static final double _kExtent = 52.h;

  TabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: maxExtent,
      child: Container(
        color: Colors.white,
        child: child,
      ),
    );
  }

  @override
  double get maxExtent => _kExtent;

  @override
  double get minExtent => _kExtent;

  @override
  bool shouldRebuild(covariant TabBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
