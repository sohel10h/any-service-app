import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOtpField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? label;
  final TextStyle? labelStyle;
  final int length;
  final double? boxSize;
  final TextStyle? textStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Function(String value)? onChanged;
  final String? Function(String?)? validator;

  const CustomOtpField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.label,
    this.labelStyle,
    this.length = 6,
    this.boxSize,
    this.textStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.onChanged,
    this.validator,
  });

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  late bool isFocused;

  @override
  void initState() {
    super.initState();
    isFocused = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (isFocused != widget.focusNode.hasFocus) {
      setState(() {
        isFocused = widget.focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = widget.textStyle ??
        TextStyle(
          fontSize: 16.sp,
          color: AppColors.text090A0A,
          fontWeight: FontWeight.w400,
        );

    final baseBorderColor = widget.borderColor ?? AppColors.borderE3E5E5;
    final focusedColor = widget.focusedBorderColor ?? AppColors.textF25B39;
    final errorColor = Theme.of(context).colorScheme.error;

    final pinTheme = PinTheme(
      width: widget.boxSize ?? 48.w,
      height: widget.boxSize ?? 48.w,
      textStyle: baseTextStyle,
      decoration: BoxDecoration(
        color: widget.fillColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: baseBorderColor),
      ),
    );

    final focusedPinTheme = pinTheme.copyWith(
      decoration: BoxDecoration(
        color: widget.fillColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: focusedColor, width: 2.w),
      ),
    );

    final errorPinTheme = pinTheme.copyWith(
      decoration: BoxDecoration(
        color: widget.fillColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: errorColor, width: 2.w),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ??
                TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.text414651,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 10.h),
        ],
        FormField<String>(
          initialValue: widget.controller.text,
          validator: widget.validator,
          builder: (FormFieldState<String> fieldState) {
            final currentDefaultTheme = fieldState.hasError ? errorPinTheme : pinTheme;
            final currentFocusedTheme = fieldState.hasError ? errorPinTheme : focusedPinTheme;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Pinput(
                  length: widget.length,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: currentDefaultTheme,
                  focusedPinTheme: currentFocusedTheme,
                  errorPinTheme: errorPinTheme,
                  separatorBuilder: (index) => SizedBox(width: 8.w),
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    fieldState.didChange(value);
                    if (fieldState.hasError) {
                      fieldState.validate();
                    }
                  },
                  cursor: Container(
                    width: 1.5.w,
                    height: 22.h,
                    color: focusedColor,
                  ),
                ),
                if (fieldState.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 4.w),
                    child: Text(
                      fieldState.errorText ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: errorColor,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
