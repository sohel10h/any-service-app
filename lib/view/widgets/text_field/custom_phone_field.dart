import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? label;
  final TextStyle? labelStyle;
  final String? hintText;
  final bool? readOnly;
  final String initialCountryCode;
  final String? Function(PhoneNumber?)? validator;
  final Function(PhoneNumber)? onChanged;
  final Function(Country)? onCountryChanged;
  final Color? fillColor;
  final OutlineInputBorder? enabledBorder;

  const CustomPhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.label,
    this.labelStyle,
    this.hintText,
    this.readOnly = false,
    this.initialCountryCode = "BD",
    this.validator,
    this.onChanged,
    this.onCountryChanged,
    this.fillColor,
    this.enabledBorder,
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  late bool isFocused;
  Country? selectedCountry;

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
            ? SizedBox.shrink()
            : Text(
                widget.label ?? "",
                style: widget.labelStyle ??
                    TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.text0D0140,
                      fontWeight: FontWeight.w600,
                    ),
              ),
        SizedBox(height: 10.h),
        IntlPhoneField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          readOnly: widget.readOnly!,
          initialCountryCode: widget.initialCountryCode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          /// ✅ DYNAMIC VALIDATOR
          validator: (phone) {
            if (phone == null || phone.number.isEmpty) {
              return "Phone number is required";
            }
            final length = phone.number.length;
            final country = selectedCountry ??
                countries.firstWhere(
                  (c) => c.code == widget.initialCountryCode,
                  orElse: () => countries.first,
                );
            final minLen = country.minLength;
            final maxLen = country.maxLength;
            // Usually, countries have fixed length (min == max)
            if (minLen == maxLen && length != maxLen) {
              return "Phone number must be $maxLen digits for ${country.name}";
            } else if (length < minLen || length > maxLen) {
              return "Phone number must be between $minLen–$maxLen digits for ${country.name}";
            }
            return null;
          },
          /// ✅ Update selected country dynamically
          onCountryChanged: (country) {
            setState(() {
              selectedCountry = country;
            });
            if (widget.onCountryChanged != null) {
              widget.onCountryChanged!(country);
            }
          },
          onChanged: widget.onChanged != null ? (phone) => widget.onChanged?.call(phone) : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor ?? AppColors.white,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: isFocused ? AppColors.text0D0140 : AppColors.text0D0140.withValues(alpha: .60),
              fontWeight: FontWeight.w400,
            ),
            border: widget.enabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
            enabledBorder: widget.enabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.borderE3E5E5),
                ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.borderE3E5E5),
            ),
          ),
        ),
      ],
    );
  }
}
