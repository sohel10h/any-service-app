import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';

class DraggableImageGrid extends StatelessWidget {
  final RxList items;
  final RxList<bool> loadingFlags;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(int) onRemove;

  const DraggableImageGrid({
    super.key,
    required this.items,
    required this.loadingFlags,
    required this.onReorder,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final double itemHeight = 90.h;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Obx(() {
        return SizedBox(
          height: itemHeight,
          child: Row(
            children: List.generate(items.length, (index) {
              final image = items[index];
              final isLoading = loadingFlags.length > index ? loadingFlags[index] : false;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: LongPressDraggable<int>(
                  data: index,
                  feedback: _buildDragImage(image),
                  childWhenDragging: Opacity(
                    opacity: 0.4,
                    child: _buildImageItem(image, index, isLoading),
                  ),
                  child: DragTarget<int>(
                    onAcceptWithDetails: (oldIndex) {
                      if (oldIndex.data != index) onReorder(oldIndex.data, index);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return _buildImageItem(image, index, isLoading);
                    },
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildDragImage(dynamic image) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.file(
          File(image.path),
          width: 80.w,
          height: 80.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildImageItem(dynamic image, int index, bool isLoading) {
    return SizedBox(
      width: 90.w,
      height: 90.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.file(
              File(image.path),
              width: 90.w,
              height: 90.h,
              fit: BoxFit.cover,
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: CustomProgressBar(),
            ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => onRemove(index),
              child: Icon(Icons.cancel, color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}
