import 'package:flutter/material.dart';
import 'package:saranportfolio/common/constants/color_constant.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final InputCounterWidgetBuilder? buildCounter;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry contentPadding;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showCursor;
  final Color? cursorColor;
  final TextAlign textAlign;
  final bool? enabledInteractiveSelection;
  final String? errorText;
  final double? fontSize;
  final double? borderWidth;

  const CustomTextfield({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.buildCounter,
    this.style,
    this.hintStyle,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 14,
      horizontal: 12,
    ),
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.showCursor = true,
    this.cursorColor,
    this.textAlign = TextAlign.start,
    this.enabledInteractiveSelection,
    this.errorText,
    this.fontSize,
    this.borderWidth,
  });

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: color, width: borderWidth ?? 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autofocus: autofocus,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      buildCounter: buildCounter,
      style:
          style ??
          TextStyle(
            color: ColorConstant.secondary,
            fontSize: fontSize ?? 14,
            letterSpacing: 2,
          ),
      decoration: InputDecoration(
        hintText: hintText ?? 'Enter Value',
        hintStyle: hintStyle ?? const TextStyle(color: ColorConstant.grey),
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // Adding borders
        enabledBorder: _buildBorder(ColorConstant.primary),
        focusedBorder: _buildBorder(ColorConstant.primary),
        errorBorder: _buildBorder(ColorConstant.roseRed),
        focusedErrorBorder: _buildBorder(ColorConstant.roseRed),
        disabledBorder: _buildBorder(Colors.grey.shade600),
      ),
      readOnly: readOnly,
      showCursor: showCursor,
      cursorColor: cursorColor ?? ColorConstant.white,
      textAlign: textAlign,
    );
  }
}
