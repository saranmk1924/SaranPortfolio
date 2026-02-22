import 'package:flutter/material.dart';
import 'package:saranportfolio/common/constants/color_constant.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? fontSize;
  final FontWeight fontWeight;
  final double elevation;
  final BorderSide? border;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
    this.fontSize,
    this.fontWeight = FontWeight.bold,
    this.elevation = 0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorConstant.primary,
        foregroundColor: textColor ?? Colors.white,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: border ?? BorderSide.none,
        ),
        elevation: elevation,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
