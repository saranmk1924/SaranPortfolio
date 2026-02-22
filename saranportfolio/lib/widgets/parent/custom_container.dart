import 'package:flutter/material.dart';
import 'package:saranportfolio/common/constants/color_constant.dart';

class CustomContainer extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? foregroundDecoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Widget? child;
  final Clip clipBehavior;

  const CustomContainer({
    super.key,
    this.alignment,
    this.padding,
    this.color,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: padding,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      foregroundDecoration: foregroundDecoration,
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstant.primary, width: 4),
        gradient: LinearGradient(
          colors: [ColorConstant.background, ColorConstant.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
