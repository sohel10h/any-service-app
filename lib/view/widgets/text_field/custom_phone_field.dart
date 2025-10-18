import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? label;
  final bool? readOnly;
  final String initialCountryCode;
  final String? Function(PhoneNumber?)? validator;

  const CustomPhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.label,
    this.readOnly = false,
    this.initialCountryCode = "BD",
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == null
            ? SizedBox.shrink()
            : Text(
                label ?? "",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
        SizedBox(height: 10.h),
        IntlPhoneField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly!,
          initialCountryCode: initialCountryCode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator ?? (phone) => (phone?.number.isEmpty ?? true) ? "Phone number is required" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
