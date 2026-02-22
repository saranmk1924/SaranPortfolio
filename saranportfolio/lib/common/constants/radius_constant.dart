import 'package:flutter/material.dart';

class RadiusConstant {
  // Double values
  static const double zero = 0.0;
  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double smd = 6.0;
  static const double md = 8.0;
  static const double mdx = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 1000.0; // For circular shapes

  // BorderRadius constants
  static const BorderRadius radiusZero = BorderRadius.all(Radius.circular(zero));
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusSMD = BorderRadius.all(Radius.circular(smd));
  static const BorderRadius radiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusMDX = BorderRadius.all(Radius.circular(mdx));
  static const BorderRadius radiusLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXXL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));
}
