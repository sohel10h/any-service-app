import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onMic;
  final VoidCallback onEmoji;
  final VoidCallback onAttachment;
  final VoidCallback onCamera;
  final RxBool isTyping;

  const ChatsInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onMic,
    required this.onEmoji,
    required this.onAttachment,
    required this.onCamera,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: (val) => isTyping.value = val.trim().isNotEmpty,
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text717680.withValues(alpha: .60),
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined, size: 18.sp),
                    color: AppColors.text6A7282,
                    onPressed: onEmoji,
                  ),
                  suffixIcon: Obx(() {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.attach_file, size: 18.sp),
                          color: AppColors.text6A7282,
                          onPressed: onAttachment,
                        ),
                        if (!isTyping.value)
                          IconButton(
                            icon: Icon(Icons.camera_alt_outlined, size: 18.sp),
                            color: AppColors.text6A7282,
                            onPressed: onCamera,
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Obx(() {
              return CircleAvatar(
                backgroundColor: AppColors.primary,
                child: IconButton(
                  icon: Icon(
                    isTyping.value ? Icons.send : Icons.mic,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (isTyping.value) {
                      onSend();
                      controller.clear();
                      isTyping.value = false;
                    } else {
                      onMic();
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
