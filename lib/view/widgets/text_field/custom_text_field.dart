import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/text_field/custom_decimal_text_input_formatter.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? label;
  final TextStyle? labelStyle;
  final String? prefixIconPath;
  final TextStyle? style;
  final String hintText;
  final TextStyle? hintStyle;
  final double? height;
  final int? maxLines;
  final bool? obscureText;
  final bool? readonly;
  final Widget? suffixIcon;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final int? decimalRange;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String value)? onChanged;
  final String? Function(String?)? validator;
  final OutlineInputBorder? enabledBorder;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.label,
    this.labelStyle,
    this.prefixIconPath,
    required this.hintText,
    this.style,
    this.hintStyle,
    this.height,
    this.maxLines,
    this.obscureText,
    this.readonly = false,
    this.suffixIcon,
    this.textInputType,
    this.inputFormatters,
    this.decimalRange,
    this.textInputAction,
    this.fillColor,
    this.contentPadding,
    this.onChanged,
    this.validator,
    this.enabledBorder,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label == null
            ? const SizedBox.shrink()
            : Text(
                widget.label ?? "",
                style: widget.labelStyle ??
                    TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.text414651,
                      fontWeight: FontWeight.w500,
                    ),
              ),
        widget.label == null ? const SizedBox.shrink() : SizedBox(height: 10.h),
        widget.height == null
            ? _child()
            : SizedBox(
                height: widget.height,
                child: _child(),
              ),
      ],
    );
  }

  Widget _child() {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText ?? false,
      focusNode: widget.focusNode,
      readOnly: widget.readonly!,
      keyboardType: widget.textInputType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      validator: (value) => widget.validator != null ? widget.validator!(value) : null,
      maxLines: widget.maxLines ?? 1,
      onChanged: widget.onChanged != null ? (value) => widget.onChanged?.call(value) : null,
      onTap: widget.readonly == true && widget.onTap != null ? widget.onTap : null,
      cursorColor: AppColors.primary,
      style: widget.style ??
          TextStyle(
            fontSize: 13.sp,
            color: AppColors.text101828,
            fontWeight: FontWeight.w500,
          ),
      inputFormatters: [
        ...?widget.inputFormatters,
        if (widget.decimalRange != null) CustomDecimalTextInputFormatter(decimalRange: widget.decimalRange!),
      ],
      decoration: InputDecoration(
        contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        prefixIcon: widget.prefixIconPath == null
            ? null
            : Padding(
                padding: EdgeInsets.all(12.r),
                child: SvgPicture.asset(
                  widget.prefixIconPath ?? "",
                  width: 16.w,
                  height: 16.h,
                  colorFilter: ColorFilter.mode(
                    isFocused ? AppColors.primary : AppColors.lightBlack,
                    BlendMode.srcIn,
                  ),
                ),
              ),
        suffixIcon: widget.suffixIcon,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            TextStyle(
              fontSize: 11.sp,
              color: isFocused ? AppColors.text717680 : AppColors.text717680.withValues(alpha: .60),
              fontWeight: FontWeight.w400,
            ),
        filled: true,
        fillColor: widget.fillColor ?? AppColors.white,
        border: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
        enabledBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.borderE3E5E5),
            ),
        focusedBorder: widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.borderE3E5E5),
            ),
      ),
    );
  }
}
