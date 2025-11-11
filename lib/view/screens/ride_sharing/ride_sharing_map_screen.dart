import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_la/view/screens/ride_sharing/controller/ride_sharing_map_controller.dart';

class RideSharingMapScreen extends GetWidget<RideSharingMapController> {
  const RideSharingMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildMap(context)),
          _buildBottomCard(context),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Obx(() {
      final initialCamera = CameraPosition(
        target: const LatLng(34.052235, -118.243683),
        zoom: 13,
      );

      return GoogleMap(
        initialCameraPosition: initialCamera,
        onMapCreated: controller.onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: controller.polylines.toSet(),
        markers: controller.markers.toSet(),
        mapType: MapType.normal,
      );
    });
  }

  Widget _buildBottomCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12.r,
            offset: Offset(0, -6.h),
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final from = LatLng(34.052235, -118.243683);
                    final to = LatLng(34.062235, -118.253683);
                    await controller.setFromTo(from, to);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.place, color: Colors.white, size: 20.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estimate to destination', style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                              Text('1 Mins', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Icon(Icons.share, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8.r)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=12'),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BGK-5623', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                          Text('Toyota Sienna', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                          SizedBox(height: 6.h),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.payment, size: 16.sp),
                          SizedBox(width: 6.w),
                          Text('Book MoveEasy \$15.90', style: TextStyle(fontSize: 12.sp)),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text('All Set for Drop-Off?', style: TextStyle(fontSize: 12.sp)),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

// Simple min/max helpers used earlier
double min(double a, double b) => a < b ? a : b;

double max(double a, double b) => a > b ? a : b;
